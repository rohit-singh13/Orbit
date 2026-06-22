import 'package:flutter/material.dart';
import 'package:orbit/models/comment_model.dart';
import 'package:orbit/providers/comment_provider.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/services/comment_Services.dart';
import 'package:orbit/widgets/comment_tile.dart';
import 'package:provider/provider.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
        ),

        const Divider(),

        Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: CommentServices().streamComments(
                widget.postId
              ),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final comments = snapshot.data ?? [];
                if(comments.isEmpty) {
                  return const Center(
                    child: Text("No comments yet"),
                  );
                }
                return ListView.builder(
                  itemCount: comments.length,
                    itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentTile(
                      comment: comment,
                      onDelete: () async {
                        await context.read<CommentProvider>().deleteComment(
                            postId: widget.postId,
                            commentId: comment.id);
                      },
                    );
                    }
                );
              },
            )
        ),

        Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: "Add a comment...",
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  _submitComment();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();

    if (text.isEmpty) return;

    final user = context.read<UserProvider>().user;

    if (user == null) return;

    final success = await context.read<CommentProvider>().addComment(
      postId: widget.postId,
      userId: user.uid,
      userName: user.name,
      userImageUrl: user.imageUrl,
      text: text,
    );

    if (success) {
      _commentController.clear();
    }
  }
}