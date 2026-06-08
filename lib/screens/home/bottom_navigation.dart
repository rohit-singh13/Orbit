import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
              context,
              SizedBox(
                height: 32,
                width: 32,
                child: Center(
                    child: const Icon(Icons.wechat_outlined, size: 28,)),
              ),
              1),
          _navItem(
              context,
              SizedBox(
                height: 32,
                width: 32,
                child: Center(
                    child: const Icon(Icons.play_circle_fill_outlined, size: 28,)),
              ),
              3),
          _navItem(
              context,
              SizedBox(
                height: 35,
                  width: 35,
                  child: Center(
                      child: Image.asset('assets/logo/bottom_img.png',
                        fit: BoxFit.contain,
                        color: currentIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)))),
              0),
          _navItem(
              context,
              SizedBox(
                height: 32,
                width: 32,
                child: Center(
                    child: const Icon(Icons.explore, size: 28,)),
              ),
              4),
          _navItem(
              context,
              SizedBox(
                height: 32,
                width: 32,
                child: Center(
                    child: const Icon(Icons.person_outline, size: 28,)),
              ),
              2),

        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, Widget icon, int index ) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
