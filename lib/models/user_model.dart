
class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  final String? bio;
  final String? gender;
  final String? pronouns;
  final String? imageUrl;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.bio,
    this. gender,
    this.pronouns,
    this.imageUrl
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
      "imageUrl": imageUrl
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
      imageUrl: map["imageUrl"]
    );
  }
}