import 'package:cloud_firestore/cloud_firestore.dart';
class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final String type;
  final DateTime createdAt;
  final List<String> readBy;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.readBy
});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'readBy': readBy
    };
  }

  factory MessageModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return MessageModel(
        id: id,
        senderId: map['senderId'] ?? '',
        text: map['text'] ?? '',
        type: map['type'] ?? 'text',
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        readBy: List<String>.from(map['readBy'] ?? [])
    );
  }
}