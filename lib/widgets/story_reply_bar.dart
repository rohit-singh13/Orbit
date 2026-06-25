import 'package:flutter/material.dart';

class StoryReplyBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final FocusNode focusNode;
  final bool isSending;

  const StoryReplyBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.focusNode,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Reply to story...",
                hintStyle: const TextStyle(
                  color: Colors.white70
                ),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none
                )
              ),
            )
        ),
        const SizedBox(width: 8,),
        CircleAvatar(
          child: IconButton(
            onPressed: isSending ? null : onSend, icon: isSending ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : const Icon(Icons.send),
          ),
        )
      ],
    );
  }
}
