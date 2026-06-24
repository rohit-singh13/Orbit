import 'package:orbit/models/story_model.dart';

class StoryGroupModel {
  final String userId;
  final String userName;
  final String? userImageUrl;

  final List<StoryModel> stories;

  StoryGroupModel({
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.stories
  });
}