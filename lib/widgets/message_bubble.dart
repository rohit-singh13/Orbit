import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime createdAt;
  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14
        ),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(fontSize: 18, height: 1.3, color: isMe ? Colors.white : Colors.black87),),
            SizedBox( height: 4,),
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(_formatTime(createdAt), style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.black54,),)
              ]
              )
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final displayHour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return "$displayHour:$minute:$period";
}
