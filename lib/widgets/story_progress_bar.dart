import 'package:flutter/material.dart';

class StoryProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalStories;
  final double progress;

  const StoryProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalStories,
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          totalStories,
          (index) {
            double value;
            if(index < currentIndex) {
              value = 1;
            }
            else if (index > currentIndex) {
              value = 0;
            }
            else {
              value = progress;
            }
            return Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: LinearProgressIndicator(value: value,),
                ));
          }),
    );
  }
}
