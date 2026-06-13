import 'package:orbit/models/friend_request_model.dart';
import 'package:orbit/services/friend_services.dart';
import 'package:flutter/material.dart';

class FriendProvider extends ChangeNotifier{
  final FriendServices _friendServices = FriendServices();
  List<FriendRequestModel> _incomingRequests = [];

  List<FriendRequestModel> get incomingRequests => _incomingRequests;

  Future<void> loadIncomingRequests (
      String uid
      ) async {
    _incomingRequests = await _friendServices.getIncomingRequests(uid);

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