import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/post_model.dart';
import 'package:orbit/services/cloudinary_service.dart';
import 'package:orbit/services/post_services.dart';

class PostProvider extends ChangeNotifier{
  final PostServices _postService = PostServices();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> createPost({
    required String caption,
    required List<String> imagePaths,
    required String userName,
    String? userImageUrl
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final List<String> imageUrls = await _cloudinaryService.uploadImages(imagePaths);

      if(imageUrls.isEmpty) {
        throw Exception("Failed to upload images");
      }
      final String postId = _postService.generatePostId();

      final PostModel post = PostModel(
          id: postId,
          userId: FirebaseAuth.instance.currentUser!.uid,
          caption: caption,
          imageUrls: imageUrls,
          likesCount: 0,
          commentsCount: 0,
          createdAt: DateTime.now(),
          userName: userName,
          userImageUrl: userImageUrl
      );
      await _postService.createPost(post);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _postService.deletePost(postId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(
      String postId
      ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _postService.toggleLike(postId, uid);
  }
}