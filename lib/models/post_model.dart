class PostModel {
  final String id;
  final String userId;
  final String caption;
  final List<String> imageUrls;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final String userName;
  final String? userImageUrl;

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrls,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.userName,
    required this.userImageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "caption": caption,
      "imageUrls": imageUrls,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "createdAt": createdAt.toIso8601String(),
      "userName": userName,
      "userImageUrl": userImageUrl,
    };
  }

  factory PostModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return PostModel(
      id: map["id"],
      userId: map["userId"],
      caption: map["caption"] ?? "",
      imageUrls: List<String>.from(map["imageUrls"] ?? [],),
      likesCount: map["likesCount"] ?? 0,
      commentsCount: map["commentsCount"] ?? 0,
      createdAt: DateTime.parse(map["createdAt"],),
      userName: map["userName"],
      userImageUrl: map["userImageUrl"],
    );
  }
}