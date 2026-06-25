import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';

class StoryAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  final bool hasStory;
  final bool hasViewedAll;
  final bool showAddButton;

  final VoidCallback? onTap;
  const StoryAvatar({
    super.key,
    this.imageUrl,
    this.radius = 85,
    this.hasStory = false,
    this.hasViewedAll = false,
    this.showAddButton = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? Icon(Icons.person, size: radius,) : null,
    );

    if(hasStory) {
      avatar = Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasViewedAll ? null : const LinearGradient(colors: [Colors.purple, Colors.pink, Colors.orange]),
          color: hasViewedAll ? Colors.grey : null
        ),
        child: avatar,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (showAddButton)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createStory,);
                  },
                  iconSize: 18,
                ),
              ),
            ),
        ],
      )
    );
  }
}
