import 'package:flutter/material.dart';
import 'package:orbit/models/comment_model.dart';
import 'package:orbit/services/comment_Services.dart';

class CommentProvider extends ChangeNotifier{
  final CommentServices _commentServices = CommentServices();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> addComment({
    required String postId,
    required String userId,
    required String userName,
    String? userImageUrl,
    required String text
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final commentId = _commentServices.generateCommentId(postId);
      final comment = CommentModel(
          id: commentId,
          userId: userId,
          postId: postId,
          userName: userName,
          userImageUrl: userImageUrl,
          text: text,
          createdAt: DateTime.now()
      );

      await _commentServices.addComment(postId, comment);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId
  }) async {
    try{
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _commentServices.deleteComment(postId, commentId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}