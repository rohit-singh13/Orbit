import 'package:flutter/material.dart';
import 'package:orbit/models/post_model.dart';
import 'package:orbit/services/post_services.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _currentImageIndex = 0;
  late Future<PostModel?> _postFuture;
  final PageController _pageController = PageController();
  bool _initialized = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final postId = ModalRoute.of(context)!.settings.arguments as String;
      _postFuture = PostServices().getPost(postId);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: FutureBuilder<PostModel?>(
          future: _postFuture,
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Post not found"),
              );
            }
            final post = snapshot.data!;
            print("POST DETAIL REBUILT");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: post.userImageUrl != null ? NetworkImage(post.userImageUrl!) : null,
                    child: post.userImageUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(post.userName),
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
                  padding: const EdgeInsets.all(16),
                  child: Text(post.caption),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(post.createdAt.toString()),
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
}
