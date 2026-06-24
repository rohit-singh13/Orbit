import 'package:orbit/models/story_model.dart';

class StoryViewerArguments {
  final List<StoryModel> stories;
  final int initialIndex;

  StoryViewerArguments({
    required this.stories,
    this.initialIndex = 0
  });
}