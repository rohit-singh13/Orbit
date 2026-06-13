
class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? bio;
  final String? gender;
  final String? pronouns;
  final String? imageUrl;
  final bool privateAccount;
  final int friendsCount;
  final int requestsCount;
  final String nameLower;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.bio,
    this. gender,
    this.pronouns,
    this.imageUrl,
    required this.privateAccount,
    required this.friendsCount,
    required this.requestsCount,
    required this.nameLower,
  });
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "createdAt": createdAt.toIso8601String(),
      "bio": bio,
      "gender": gender,
      "pronouns": pronouns,
      "imageUrl": imageUrl,
      "privateAccount": privateAccount,
      "friendsCount": friendsCount,
      "requestsCount": requestsCount,
      "nameLower": name.toLowerCase(),
    };
  }

  factory UserModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return UserModel(
        uid: map["uid"],
        name: map["name"],
        email: map["email"],
        createdAt: DateTime.parse(map["createdAt"]),
      bio: map["bio"],
      gender: map["gender"],
      pronouns: map["pronouns"],
      imageUrl: map["imageUrl"],
      privateAccount: map["privateAccount"] ?? false,
      friendsCount: map["friendsCount"] ?? 0,
      requestsCount: map["requestsCount"] ?? 0,
      nameLower: map["nameLower"],
    );
  }
}