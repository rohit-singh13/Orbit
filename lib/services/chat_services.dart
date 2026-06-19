import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/chat_model.dart';
import 'package:orbit/models/message_model.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getChatId(
      String uid1,
      String uid2
      ) {
    final ids = [uid1, uid2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
  Future<void> createChat(
      String otherUserId
      ) async {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, otherUserId);
    final chatRef = _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId);
    final doc = await chatRef.get();
    if(doc.exists) return;
    final now = DateTime.now();
    final chat = ChatModel(
        id: chatId,
        participants: [currentUid, otherUserId],
        lastMessage: '',
        lastMessageType: 'text',
        lastMessageSenderId: '',
        lastMessageTime: null,
        unreadCounts: {currentUid: 0, otherUserId: 0},
        createdAt: now,
        updatedAt: now,
        typingUsers: [],
    );
    await chatRef.set(chat.toMap());
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text
}) async {
    if(text.trim().isEmpty) return;
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, receiverId);
    print('Current User: ${_auth.currentUser?.uid}');
    print('Receiver: $receiverId');
    print('Chat ID: $chatId');
    await createChat(receiverId);
    final chatRef = _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId);
    final messageRef = chatRef.collection(FirebaseCollections.messages).doc();
    final now = DateTime.now();
    final message = MessageModel(
        id: messageRef.id,
        senderId: currentUid,
        text: text.trim(),
        type: 'text',
        createdAt: now,
        readBy: [currentUid]
    );
    await messageRef.set(message.toMap());
    await chatRef.update({
      'lastMessage': text.trim(),
      'lastMessageType': 'text',
      'lastMessageSenderId': currentUid,
      'lastMessageTime': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'unreadCounts.$receiverId': FieldValue.increment(1)
    });
  }

  Future<void> markChatAsRead(String otherUserId) async {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, otherUserId);
    await _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId)
        .update({'unreadCounts.$currentUid': 0});
  }

  Future<void> markMessagesAsRead(
      String otherUserId
      ) async {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, otherUserId);
    final messages = await _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId)
        .collection(FirebaseCollections.messages)
        .where('senderId', isEqualTo: otherUserId)
        .get();

    final batch = _firestore.batch();
    for(final doc in messages.docs) {
      final readBy = List<String>.from(doc.data()['readBy'] ?? []);
      if(!readBy.contains(currentUid)) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([currentUid])
        }
        );
      }
    }
    await batch.commit();
  }

  Stream<List<MessageModel>> streamMessages(String otherUserId,) {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, otherUserId);
    return _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId)
        .collection(FirebaseCollections.messages)
        .orderBy('createdAt', descending: false,)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(
                (doc) {
              return MessageModel.fromMap(
                doc.id,
                doc.data(),
              );
            },
          ).toList(),
    );
  }

  Stream<List<ChatModel>> streamChats() {
    final currentUid = _auth.currentUser!.uid;
    return _firestore
        .collection(FirebaseCollections.chats)
        .where('participants', arrayContains: currentUid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
        (snapshots) => snapshots.docs.map((doc) {
          return ChatModel.fromMap(doc.id, doc.data());
    },
    ).toList()
    );
  }

  Future<void> setTypingStatus({
    required String otherUserId,
    required bool isTyping,
  }) async {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(
      currentUid,
      otherUserId,
    );
    final chatRef = _firestore
        .collection(FirebaseCollections.chats)
        .doc(chatId);
    if (isTyping) {
      await chatRef.update({
        'typingUsers': FieldValue.arrayUnion(
          [currentUid],
        ),
      });
    } else {
      await chatRef.update({
        'typingUsers': FieldValue.arrayRemove(
          [currentUid],
        ),
      });
    }
  }

  Stream<ChatModel?> streamChat(
      String otherUserId
      ) {
    final currentUid = _auth.currentUser!.uid;
    final chatId = getChatId(currentUid, otherUserId);
    return _firestore.collection(FirebaseCollections.chats).doc(chatId).snapshots().map((doc) {
      if(!doc.exists) return null;
      return ChatModel.fromMap(doc.id, doc.data()!);
    });
  }

}
