import 'package:flutter/material.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/story_avatar.dart';
import 'package:orbit/widgets/story_viewer_arguments.dart';

class MyStoryWidget extends StatelessWidget {
  final String? imageUrl;
  final List<StoryModel> stories;
  const MyStoryWidget({
    super.key,
    required this.imageUrl,
    required this.stories
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStory = stories.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        StoryAvatar(
          imageUrl: imageUrl,
          radius: screenWidth * 0.22,
          hasStory: hasStory,
          hasViewedAll: false,
          showAddButton: true,
          onTap: () {
            if(!hasStory) {
              Navigator.pushNamed(context, AppRoutes.createStory);
            } else {
              Navigator.pushNamed(
                  context,
                  AppRoutes.viewStory,
                arguments: StoryViewerArguments(stories: stories)
              );
            }
          },
        ),

        SizedBox(height: 10,),

        const Text("My Story", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
      ],
    );
  }
}
