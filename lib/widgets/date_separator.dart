import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final String text;

  const DateSeparator({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12,),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}