import 'package:flutter/material.dart';
import 'package:orbit/models/story_group_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/story_avatar.dart';
import 'package:orbit/widgets/story_viewer_arguments.dart';

class FriendStoryTile extends StatelessWidget {
  final StoryGroupModel storyGroup;
  final bool hasViewedAll;
  final VoidCallback? onTap;
  const FriendStoryTile({
    super.key,
    required this.storyGroup,
    required this.hasViewedAll,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StoryAvatar(
            imageUrl: storyGroup.userImageUrl,
            radius: 42,
            hasStory: true,
            hasViewedAll: hasViewedAll,
            onTap: () {
              Navigator.pushNamed(
                  context,
                  AppRoutes.viewStory,
                arguments: StoryViewerArguments(stories: storyGroup.stories)
              );
            },
          ),
          SizedBox(height: 8,),

          SizedBox(
            width: 100,
            child: Text(
              storyGroup.userName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
