class StoryModel {
  final String storyId;
  final String userId;
  final String imageUrl;

  final String userName;
  final String? userImageUrl;

  final DateTime createdAt;
  final DateTime expiresAt;

  final List<String> viewers;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.imageUrl,
    required this.createdAt,
    required this.expiresAt,
    required this.viewers
  });

  Map<String, dynamic> toMap() {
    return {
      "storyId": storyId,
      "userId": userId,
      "imageUrl": imageUrl,
      "userName": userName,
      "userImageUrl": userImageUrl,
      "createdAt": createdAt.toIso8601String(),
      "expiresAt": expiresAt.toIso8601String(),
      "viewers": viewers,
    };
  }

  factory StoryModel.fromMap(
      Map<String, dynamic> map
      ) {
    return StoryModel(
        storyId: map["storyId"],
        userId: map["userId"],
        userName: map["userName"],
        userImageUrl: map["userImageUrl"],
        imageUrl: map["imageUrl"],
        createdAt: DateTime.parse(map["createdAt"]),
        expiresAt: DateTime.parse(map["expiresAt"]),
        viewers: List<String>.from(map["viewers"] ?? [])
    );
  }

  StoryModel copyWith({
    String? storyId,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewers
  }) {
    return StoryModel(
        storyId: storyId ?? this.storyId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userImageUrl: userImageUrl ?? this.userImageUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        viewers: viewers ?? this.viewers
    );
  }
}