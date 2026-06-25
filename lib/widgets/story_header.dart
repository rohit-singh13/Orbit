import 'package:flutter/material.dart';
import 'package:orbit/models/story_model.dart';

class StoryHeader extends StatelessWidget {
  final StoryModel story;
  final bool isOwner;
  final String timeAgo;
  final VoidCallback onBack;
  final VoidCallback onDelete;
  const StoryHeader({
    super.key,
    required this.story,
    required this.isOwner,
    required this.timeAgo,
    required this.onBack,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: Colors.white,)
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: story.userImageUrl != null ? NetworkImage(story.userImageUrl!) : null,
          ),
          const SizedBox(width: 10,),
          Expanded(
              child: Text(story.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
          Text(
              timeAgo,
            style: const TextStyle(color: Colors.white70),
          ),
          if(isOwner)
            PopupMenuButton<String>(
              onSelected: (value) {
                if(value == "delete"){
                  onDelete();
                }
              },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "delete",
                      child: Text("Delete Story", style: TextStyle(color: Colors.red),)
                  )
                ]
            ),

          if(!isOwner)
            IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.close, color: Colors.white,)
            )
        ],
      ),
    );
  }
}
