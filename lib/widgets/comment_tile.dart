import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onDelete;

   CommentTile({
    super.key,
    required this.comment,
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isOwner = currentUserId == comment.userId;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: comment.userImageUrl != null ? NetworkImage(comment.userImageUrl!) : null,
        child: comment.userImageUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(
        comment.userName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.text),
          const SizedBox(height: 4,),
          Text(
            getTimeAgo(comment.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
      trailing: isOwner ? IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline)) : null,
    );
  }

  String getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if(difference.inSeconds < 60) {
      return "${difference.inSeconds}s";
    }
    if(difference.inMinutes < 60) {
      return "${difference.inMinutes}m";
    }
    if(difference.inHours < 24) {
      return "${difference.inHours}h";
    }
    return "${difference.inDays}d";
  }
}