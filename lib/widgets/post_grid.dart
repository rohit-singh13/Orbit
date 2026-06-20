import 'package:flutter/material.dart';
import 'package:orbit/models/post_model.dart';
import 'package:orbit/routes/app_routes.dart';

class PostGrid extends StatelessWidget {
  final List<PostModel> posts;
  const PostGrid({
    super.key,
    required this.posts
  });

  @override
  Widget build(BuildContext context) {
    if(posts.isEmpty) {
      return const Column(
        children: [
          Icon(Icons.photo_library_outlined, size: 80,),
          SizedBox(height: 15,),
          Text("No Posts Yet")
        ],
      );
    }
    return GridView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.postDetails, arguments: post.id);
          },
          child: Image.network(
              post.imageUrls.first,
              fit: BoxFit.cover,
          ),
        );
        });
  }
}
