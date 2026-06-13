import 'package:cloud_firestore/cloud_firestore.dart';

class FriendshipModel {
  final String id;
  final String userA;
  final String userB;
  final DateTime createdAt;
  FriendshipModel({
    required this.id,
    required this.userA,
    required this.userB,
    required this.createdAt
});

  Map<String, dynamic> toMap () {
    return {
      "userA": userA,
      "userB": userB,
      "createdAt": createdAt
    };
  }

  factory FriendshipModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return FriendshipModel(
      id: id,
      userA: "userA",
      userB: "userB",
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }
}