import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/services/cloudinary_service.dart';
import 'package:orbit/services/story_services.dart';

class StoryProvider extends ChangeNotifier{
  final StoryServices _storyServices = StoryServices();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> createStory({
    required String imagePath,
    required String userName,
    String? userImageUrl
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final List<String> imageUrls = await _cloudinaryService.uploadImages([imagePath]);
      if(imageUrls.isEmpty) {
        throw Exception("Failed to upload story");
      }

      final String storyId = _storyServices.generateStoryId();
      final StoryModel story = StoryModel(
          storyId: storyId,
          userId: FirebaseAuth.instance.currentUser!.uid,
          userName: userName,
          userImageUrl: userImageUrl,
          imageUrl: imageUrls.first,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
          viewers: []
      );
      await _storyServices.createStory(story);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markViewed(
      String storyId
      ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _storyServices.markViewed(storyId: storyId, viewerId: uid);
  }

  Future<void> deleteStory(
      String storyId
      ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _storyServices.deleteStory(storyId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}