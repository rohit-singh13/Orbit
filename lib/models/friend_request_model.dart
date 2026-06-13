import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime createdAt;
  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt
});
  Map<String, dynamic> toMap() {
    return{
      "senderId": senderId,
      "receiverId": receiverId,
      "status": status,
      "createdAt": Timestamp.fromDate(createdAt)
    };
  }

  factory FriendRequestModel.fromMap(
      String id,
      Map<String, dynamic> map
      ) {
    return FriendRequestModel(
        id: id,
        senderId: map["senderId"],
        receiverId: map["receiverId"],
        status: map["status"],
        createdAt: (map["createdAt"] as Timestamp).toDate(),
    );

  }
}
