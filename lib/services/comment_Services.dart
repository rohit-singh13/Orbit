import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/comment_model.dart';

class CommentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateCommentId(
      String postId
      ) {
    return _firestore
        .collection(FirebaseCollections.posts)
        .doc(postId)
        .collection("comments")
        .doc()
        .id;
  }

  Future<void> addComment(
      String postId,
      CommentModel comment
      ) async {
    final postRef = _firestore.collection(FirebaseCollections.posts).doc(postId);
    final commentRef = postRef.collection("comments").doc(comment.id);

    await _firestore.runTransaction((transaction) async {
      transaction.set(commentRef, comment.toMap());

      transaction.update(postRef, {
        "commentsCount": FieldValue.increment(1)
      });
    });
  }

  Future<void> deleteComment(
      String postId,
      String commentId
      ) async {
    final postRef = _firestore.collection(FirebaseCollections.posts).doc(postId);
    final commentRef = postRef.collection("comments").doc(commentId);

    await _firestore.runTransaction((transaction) async {
      transaction.delete(commentRef);

      transaction.update(postRef,
          {
            "commentsCount": FieldValue.increment(-1)
          });
    });
  }

  Stream<List<CommentModel>> streamComments(
      String postId
      ) {
    return _firestore
        .collection(FirebaseCollections.posts)
        .doc(postId)
        .collection("comments")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
            (snapshot) => snapshot.docs
                .map(
                    (doc) => CommentModel.fromMap(
                        doc.data(),
                    ),
            ).toList(),
    );
  }
}