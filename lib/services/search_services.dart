import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/user_model.dart';

class SearchServices {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchUsers(
      String query
      ) async {
    if(query.trim().isEmpty) {
      return [];
    }
    final searchQuery = query.toLowerCase();
    final snapshot = await _firestore.collection(FirebaseCollections.users)
        .where("nameLower", isGreaterThanOrEqualTo: searchQuery)
        .where("nameLower", isLessThanOrEqualTo: "$searchQuery\uf8ff").get();
    return snapshot.docs.map((doc) {
      return UserModel.fromMap(
        doc.data(),
      );
    },).toList();
  }
  // later use of Algolia
}