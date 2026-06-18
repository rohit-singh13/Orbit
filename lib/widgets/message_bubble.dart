import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final DateTime createdAt;
  final List<String> readBy;
  final bool showReadReceipt;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.createdAt,
    required this.readBy,
    required this.showReadReceipt,
    required this.isFirstInGroup,
    required this.isLastInGroup,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool showTime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showTime = !showTime;
        });
      },
      child: Align(
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              margin: EdgeInsets.only(
                left: 8,
                right: 8,
                top: widget.isFirstInGroup ? 8 : 1,
                bottom: widget.isLastInGroup ? 8 : 1,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: widget.isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.isMe ? 18 : (widget.isFirstInGroup ? 18 : 6),
                  ),
                  topRight: Radius.circular(
                    widget.isMe ? (widget.isFirstInGroup ? 18 : 6) : 18,
                  ),
                  bottomLeft: Radius.circular(
                    widget.isMe ? 18 : (widget.isLastInGroup ? 18 : 6),
                  ),
                  bottomRight: Radius.circular(
                    widget.isMe ? (widget.isLastInGroup ? 18 : 6) : 18,
                  ),
                ),
              ),

              child: Text(widget.text, style: TextStyle(fontSize: 18, height: 1.3, color: widget.isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),

            if (showTime)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14,),
                child: Column(
                  crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(_formatTime(widget.createdAt), style: const TextStyle(fontSize: 10, color: Colors.grey,
                      ),
                    ),
                    if (widget.isMe && widget.showReadReceipt)
                      Text(widget.readBy.length > 1 ? 'Seen' : 'Sent', style: const TextStyle(fontSize: 10, color: Colors.grey,)),
                  ],
                ),
              ),
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
  return '$displayHour:$minute $period';
}