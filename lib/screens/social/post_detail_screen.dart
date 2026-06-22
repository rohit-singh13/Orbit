import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/post_model.dart';
import 'package:orbit/providers/post_provider.dart';
import 'package:orbit/services/post_services.dart';
import 'package:orbit/widgets/comments_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _currentImageIndex = 0;
  late Stream<PostModel?> _postStream;
  final PageController _pageController = PageController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final postId = ModalRoute.of(context)!.settings.arguments as String;
      _postStream = PostServices().streamPost(postId);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: StreamBuilder<PostModel?>(
          stream: _postStream,
          builder: ((context, snapshot) {
            if(!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data == null) {
              return const Center(
                child: Text("Post not found"),
              );
            }
            final post = snapshot.data!;
            final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            final isOwner = currentUserId == post.userId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: post.userImageUrl != null ? NetworkImage(post.userImageUrl!) : null,
                    child: post.userImageUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(post.userName),
                  trailing: isOwner ? IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () => _confirmDelete(post.id),
                      icon: Icon(Icons.more_vert))
                      : null,
                ),
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: post.imageUrls.length,
                      onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                      },
                      itemBuilder: ((context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              post.imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ],
                        );
                      }
                      )
                  ),
                ),
                if (post.imageUrls.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        post.imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentImageIndex == index ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _currentImageIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                            ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.caption),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      StreamBuilder<bool>(
                        stream: PostServices().isPostLiked(
                          post.id,
                          FirebaseAuth.instance.currentUser!.uid,
                        ),
                        builder: (context, snapshot) {
                          final isLiked = snapshot.data ?? false;
                          return IconButton(
                            onPressed: () {
                              context.read<PostProvider>().toggleLike(post.id);
                            },
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                          );
                        },
                      ),
                      Text("${post.likesCount}", style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          _showComments(post);
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                      ),
                      Text(
                        "${post.commentsCount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            );
          })),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(String postId) async {
    final confirmed = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Deleted Posts can not be retrieved in future"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel")),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Confirm"),
              )
            ],
          );
        });
    if(confirmed == true) {
      await context.read<PostProvider>().deletePost(postId);
      if(!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Deleted")));
    }
  }
  
  void _showComments(PostModel post) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return CommentsBottomSheet(postId: post.id,);
      }
    );
  }
}
