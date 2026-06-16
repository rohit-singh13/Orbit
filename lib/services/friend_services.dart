import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/friend_request_model.dart';
import 'package:orbit/models/friendship_model.dart';

class FriendServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId
}) async {
    if (senderId == receiverId) {
      throw Exception(
        "You cannot send a friend request to yourself"
      );
    }
    final existingRequest = await _firestore.collection(FirebaseCollections.friendRequests)
    .where("senderId", isEqualTo: senderId).where("receiverId", isEqualTo: receiverId).where("status", isEqualTo: "pending").get();

    if(existingRequest.docs.isNotEmpty) {
      throw Exception(
        "Friend request already sent"
      );
    }

    final request = FriendRequestModel(
        id: "",
        senderId: senderId,
        receiverId: receiverId,
        status: "pending",
        createdAt: DateTime.now()
    );
    await _firestore.collection(FirebaseCollections.friendRequests).add(request.toMap());

  }

  Future<String?> getRequestId({
    required String currentUserId,
    required String targetUserId
}) async {
    final outgoing = await _firestore
        .collection(FirebaseCollections.friendRequests)
        .where("senderId", isEqualTo: currentUserId)
        .where("receiverId", isEqualTo: targetUserId)
        .where("status", isEqualTo: "pending")
        .get();
    if(outgoing.docs.isNotEmpty) {
      return outgoing.docs.first.id;
    }
    final incoming = await _firestore
        .collection(FirebaseCollections.friendRequests)
        .where("senderId", isEqualTo: targetUserId)
        .where("receiverId", isEqualTo: currentUserId)
        .where("status", isEqualTo: "pending")
        .get();
    if(incoming.docs.isNotEmpty) {
      return incoming.docs.first.id;
    }
    return null;
  }


  Future<void> acceptRequest({
    required String requestId,
  }) async {

    await _firestore.runTransaction(
          (transaction) async {

        final requestRef = _firestore
            .collection(FirebaseCollections.friendRequests)
            .doc(requestId);

        final requestSnapshot =
        await transaction.get(requestRef);

        if (!requestSnapshot.exists) {
          throw Exception("Request not found");
        }

        final data = requestSnapshot.data()!;

        final senderId = data["senderId"];
        final receiverId = data["receiverId"];
        
        final senderRef = _firestore.collection(FirebaseCollections.users).doc(senderId);
        final receiveRef = _firestore.collection(FirebaseCollections.users).doc(receiverId);
        
        transaction.update(
            senderRef, {
              "friendsCount": FieldValue.increment(1)
        },);
        
        transaction.update(receiveRef, {
          "friendsCount": FieldValue.increment(1)
        });

        transaction.update(
          requestRef,
          {
            "status": "accepted",
          },
        );

        final friendshipRef = _firestore
            .collection(FirebaseCollections.friendships)
            .doc();

        transaction.set(
          friendshipRef,
          {
            "userA": senderId,
            "userB": receiverId,
            "createdAt": FieldValue.serverTimestamp(),
          },
        );
      },
    );
  }

  Future<void> removeFriend({
    required String currentUserId,
    required String targetUserId
}) async {
    final friendshipA = await _firestore
        .collection(FirebaseCollections.friendships)
        .where("userA", isEqualTo: currentUserId)
        .where("userB", isEqualTo: targetUserId)
        .get();
    final friendshipB = await _firestore
        .collection(FirebaseCollections.friendships)
        .where("userA", isEqualTo: targetUserId)
        .where("userB", isEqualTo: currentUserId)
        .get();
    final friendshipDoc = friendshipA.docs.isNotEmpty ? friendshipA.docs.first : friendshipB.docs.first;
    await _firestore.runTransaction((transaction) async {
      final currentUserRef = _firestore
          .collection(FirebaseCollections.users)
          .doc(currentUserId);
      final targetUserRef = _firestore
          .collection(FirebaseCollections.users)
          .doc(targetUserId);
      transaction.update(
           currentUserRef,{
            "friendsCount": FieldValue.increment(-1)
        });
      transaction.update(
          targetUserRef, {
            "friendsCount": FieldValue.increment(-1)
          });
      transaction.delete(friendshipDoc.reference);
    });
  }

  Future<void> rejectRequest({
    required String requestId,
}) async {
    await _firestore.collection(FirebaseCollections.friendRequests).doc(requestId).update(
        {
          "status": "rejected",
        });
  }

  Future<void> cancelRequest ({
    required String requestId,
}) async {
    await _firestore.collection(FirebaseCollections.friendRequests).doc(requestId).delete();
  }

  Future<List<FriendRequestModel>> getIncomingRequests(
      String uid,
      ) async {
    final snapshot = await _firestore.collection(FirebaseCollections.friendRequests)
        .where("receiverId", isEqualTo: uid).where("status", isEqualTo: "pending").get();
    return snapshot.docs.map((doc) {
      return FriendRequestModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<List<FriendRequestModel>> getOutgoingRequests(
      String uid
      ) async {
    final snapshot = await _firestore.collection(FirebaseCollections.friendRequests)
        .where("senderId", isEqualTo: uid).where("status", isEqualTo: "pending").get();
    return snapshot.docs.map((doc) {
      return FriendRequestModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<List<FriendshipModel>> getFriends(
      String uid,
      ) async {
    final userAQuery = await _firestore
        .collection(FirebaseCollections.friendships)
        .where("userA", isEqualTo: uid)
        .get();
    final userBQuery = await _firestore
        .collection(FirebaseCollections.friendships)
        .where("userB", isEqualTo: uid)
        .get();
    final docs = [
      ...userAQuery.docs,
      ...userBQuery.docs
    ];
    return docs.map((doc) {
      return FriendshipModel.fromMap(doc.id, doc.data());
    }
      ).toList();
    }

  Future<FriendStatus> getFriendStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final friendshipA = await _firestore.collection(FirebaseCollections.friendships)
        .where("userA", isEqualTo: currentUserId)
        .where("userB", isEqualTo: targetUserId)
        .get();
    final friendshipB = await _firestore.collection(FirebaseCollections.friendships)
        .where("userB", isEqualTo: currentUserId)
        .where("userA", isEqualTo: targetUserId)
        .get();
    if(friendshipA.docs.isNotEmpty || friendshipB.docs.isNotEmpty) {
      return FriendStatus.friends;
    }

    final outgoing = await _firestore
        .collection(FirebaseCollections.friendRequests)
        .where("senderId", isEqualTo: currentUserId)
        .where("receiverId", isEqualTo: targetUserId)
        .where("status", isEqualTo: "pending")
        .get();

    if (outgoing.docs.isNotEmpty) {
      return FriendStatus.pendingOutgoing;
    }

    final incoming = await _firestore
        .collection(FirebaseCollections.friendRequests)
        .where("senderId", isEqualTo: targetUserId)
        .where("receiverId", isEqualTo: currentUserId)
        .where("status", isEqualTo: "pending")
        .get();

    if (incoming.docs.isNotEmpty) {
      return FriendStatus.pendingIncoming;
    }

    return FriendStatus.none;
  }

  }

enum FriendStatus {
  none,
  pendingOutgoing,
  pendingIncoming,
  friends
}


  // sendRequest();
  // removeFriend();
