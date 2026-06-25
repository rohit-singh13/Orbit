import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbit/firebase/firebase_collections.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/services/firestore_services.dart';

class StoryServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateStoryId() {
    return _firestore.collection(FirebaseCollections.stories).doc().id;
  }

  Future<void> createStory(
      StoryModel story
      ) async {
    await _firestore.collection(FirebaseCollections.stories).doc(story.storyId).set(story.toMap());
  }

  Stream<List<StoryModel>> streamStories() {
    return _firestore
        .collection(FirebaseCollections.stories)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();
      return snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data()))
          .where((story) => story.expiresAt.isAfter(now)).toList();
    });
  }

  Stream<List<StoryModel>> streamUserStories(
      String userId
      ) {
    return _firestore
        .collection(FirebaseCollections.stories)
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();
      return snapshot.docs.map((doc) => StoryModel.fromMap(doc.data())).where((story) => story.expiresAt.isAfter(now)).toList();
    });
  }

  Future<void> markViewed({
    required String storyId,
    required String viewerId
  }) async {
    await _firestore.collection(FirebaseCollections.stories).doc(storyId).update(
        {"viewers": FieldValue.arrayUnion([viewerId])
        });
  }

  Future<void> deleteStory(
      String storyId
      ) async {
    await _firestore.collection(FirebaseCollections.stories).doc(storyId).delete();
  }

  Future<void> markStoryViewed(
      String storyId,
      String userId,
      ) async {
    await _firestore
        .collection(
      FirebaseCollections.stories,
    ).doc(storyId).update({
      "viewers":
      FieldValue.arrayUnion([userId]),
    });
  }

  Future<List<UserModel>> getStoryViewers(
      List<String> viewerIds,
      ) async {
    List<UserModel> viewers = [];

    for (final uid in viewerIds) {
      final user =
      await FirestoreServices().getUser(uid);

      if (user != null) {
        viewers.add(user);
      }
    }

    return viewers;
  }

}