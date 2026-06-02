import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orbit/constants/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient(
          context,
        ),
      ),
      child: child,
    );
  }
}