class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.text,
    required this.createdAt
});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "userImageUrl": userImageUrl,
      "text": text,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(
      Map<String, dynamic> map
      ) {
    return CommentModel(
        id: map["id"],
        postId: map["postId"],
        userId: map["userId"],
        userName: map["userName"],
        userImageUrl: map["userImageUrl"],
        text: map["text"] ?? "",
        createdAt: DateTime.parse(map["createdAt"])
    );
  }
}