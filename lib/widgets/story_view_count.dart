import 'package:flutter/material.dart';

class StoryViewCount extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const StoryViewCount({
    super.key,
    required this.count,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.remove_red_eye,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 6,),
            Text("$count", style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
