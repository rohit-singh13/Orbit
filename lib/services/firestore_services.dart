import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/firebase/firebase_collections.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if(!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(
      String uid,
      Map<String, dynamic> data,
      ) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(uid)
        .update(data);
  }
}