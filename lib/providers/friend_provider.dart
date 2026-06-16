import 'package:orbit/models/friend_request_model.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/services/friend_services.dart';
import 'package:flutter/material.dart';
import 'package:orbit/services/firestore_services.dart';

class FriendProvider extends ChangeNotifier{
  final FriendServices _friendServices = FriendServices();
  final FirestoreServices _firestoreServices = FirestoreServices();
  List<FriendRequestModel> _incomingRequests = [];

  List<FriendRequestModel> get incomingRequests => _incomingRequests;

  List<UserModel> _friends = [];

  List<UserModel> get friends => _friends;

  Future<void> loadIncomingRequests (
      String uid
      ) async {
    _incomingRequests = await _friendServices.getIncomingRequests(uid);

    notifyListeners();
  }

  Future<void> acceptRequest (
      String requestId,
      String uid
      ) async {
    await _friendServices.acceptRequest(requestId: requestId);
    await loadIncomingRequests(uid);
    notifyListeners();
  }

  Future<void> rejectRequest(
      String requestId,
      String uid
      ) async {
    await _friendServices.rejectRequest(requestId: requestId);
    await loadIncomingRequests(uid);
    notifyListeners();
  }

  Future<void> loadFriends(
      String uid,
      ) async {
    final friendships = await _friendServices.getFriends(uid);
    List<UserModel> loadedFriends = [];
    for (final friendship in friendships) {
      final friendUid = friendship.userA == uid
          ? friendship.userB
          : friendship.userA;

      final user = await _firestoreServices.getUser(
        friendUid,
      );

      if (user != null) {
        loadedFriends.add(user);
      }
    }
    _friends = loadedFriends;
    notifyListeners();
  }
  // List<FriendRequestModel> incomingRequests;
  // List<FriendRequestModel> outgoingRequests;
  // List<UserModel> friends;
  // loadRequests();
  // loadFriends();
  // acceptRequests();
  // rejectRequests();
  // sendRequest();
}