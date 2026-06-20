import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/post_model.dart';

class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generatePostId() {
    return _firestore.collection(FirebaseCollections.posts).doc().id;
  }

  Future<void> createPost(
      PostModel post
      ) async {
    await _firestore
        .collection(FirebaseCollections.posts)
        .doc(post.id)
        .set(post.toMap());
  }

  Future<void> deletePost(
      String postId,
      ) async {
    await _firestore
        .collection(FirebaseCollections.posts)
        .doc(postId)
        .delete();
  }

  Stream<List<PostModel>> streamFeedPosts() {
    return _firestore
        .collection(FirebaseCollections.posts)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      List<PostModel> posts = snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data(),),
      ).toList();

      return posts;
    });
  }

  Stream<List<PostModel>> streamUserPosts(
      String userId,
      ) {
    return _firestore
        .collection(FirebaseCollections.posts)
        .where("userId", isEqualTo: userId,)
        .snapshots()
        .map((snapshot) {
      List<PostModel> posts = snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data(),),
      ).toList();

      return posts;
    });
  }

  Stream<int> streamPostCount(
      String userId
      ) {
    return _firestore
        .collection(FirebaseCollections.posts)
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


}
