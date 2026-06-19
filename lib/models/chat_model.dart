import 'package:cloud_firestore/cloud_firestore.dart';
class ChatModel {
  final String id;
  final List<String> participants;

  final String lastMessage;
  final String lastMessageType;
  final String lastMessageSenderId;
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCounts;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<String> typingUsers;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
    required this.unreadCounts,
    required this.createdAt,
    required this.updatedAt,
    required this.typingUsers,
});

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!)  : null,
      'unreadCounts': unreadCounts,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      "typingUsers": typingUsers,
    };
  }

  factory ChatModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return ChatModel(
        id: id,
        participants: List<String>.from(map['participants'] ?? []),
        lastMessage: map['lastMessage'] ?? '',
        lastMessageType: map['lastMessageType'] ?? 'text',
        lastMessageSenderId: map['lastMessageSenderId'] ?? '',
        lastMessageTime: map['lastMessageTime'] != null ? (map['lastMessageTime'] as Timestamp).toDate() : null,
        unreadCounts: Map<String, int>.from(map['unreadCounts'] ?? {}),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        updatedAt: (map['updatedAt'] as Timestamp).toDate(),
        typingUsers: List<String>.from(map['typingUsers'] ?? []),
    );
  }
}