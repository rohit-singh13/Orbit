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
              "friendCount": FieldValue.increment(1)
        },);
        
        transaction.update(receiveRef, {
          "friendCount": FieldValue.increment(-1)
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
  }
  // sendFriendRequest();
  // sendRequest();
  // rejectRequest();
  // cancelRequest();
  // removeFriend();
  // getIncomingRequests();
  // getOutgoingRequests();
  // getFriends();
