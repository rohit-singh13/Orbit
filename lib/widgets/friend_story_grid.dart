import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/story_group_model.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/services/story_services.dart';
import 'package:orbit/widgets/friend_story_tile.dart';

class FriendStoryGrid extends StatelessWidget {
  final List<UserModel> friends;
  const FriendStoryGrid({
    super.key,
    required this.friends
  });

  List<StoryGroupModel> _groupStories(
      List<StoryModel> stories,
      ) {
    final Map<String, List<StoryModel>> grouped = {};

    for(final story in stories) {
      grouped.putIfAbsent(story.userId, () => [] );

      grouped[story.userId]!.add(story);
    }
    return grouped.entries.map((entry) {
      final firstStory = entry.value.first;

      return StoryGroupModel(
          userId: firstStory.userId,
          userName: firstStory.userName,
          userImageUrl: firstStory.userImageUrl,
          stories: entry.value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final friendsIds = friends.map((friend) => friend.uid).toSet();
    return StreamBuilder<List<StoryModel>>(
        stream: StoryServices().streamStories(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final stories = snapshot.data ?? [];

          final friendStories = stories.where(
              (story) {
                return friendsIds.contains(story.userId);
              }
          ).toList();

          final storyGroups = _groupStories(friendStories);

          if(storyGroups.isEmpty) {
            return const Center(
              child: Text("No stories available"),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: storyGroups.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                childAspectRatio: 0.9
              ),
              itemBuilder: (context, index) {
              final group = storyGroups[index];

              final hasViewedAll = group.stories.every(
                  (story) => story.viewers.contains(currentUserId)
              );

              return FriendStoryTile(
                storyGroup: group,
                hasViewedAll: hasViewedAll,
                onTap: () {
                  //open story view screen
                },
              );
              }
          );
        }
    );
  }
}
