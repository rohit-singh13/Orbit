import 'package:flutter/material.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/date_separator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbit/widgets/message_bubble.dart';

class PersonalChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String? receiverImageUrl;
  const PersonalChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    this.receiverImageUrl
  });

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final TextEditingController _messageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<ChatProvider>();
      provider.listenMessages(widget.receiverId);
      await provider.markChatAsRead(widget.receiverId);
      await provider.markMessagesAsRead(widget.receiverId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: widget.receiverImageUrl != null ? NetworkImage(widget.receiverImageUrl!) : null,
              child: widget.receiverImageUrl == null ? const Icon(Icons.person) : null,
            ),
            SizedBox( width: 12,),
            
            Expanded(child: Text(widget.receiverName, overflow: TextOverflow.ellipsis,))
          ],
        ),
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child,) {
                  final messages = provider.messages.reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount:
                    provider.messages.length,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final message = messages[index];
                      bool showDateSeparator = false;
                      if (index == messages.length - 1) {
                        showDateSeparator = true;
                      } else {
                        final nextMessage = messages[index + 1];
                        final currentDate = DateTime(
                          message.createdAt.year,
                          message.createdAt.month,
                          message.createdAt.day,
                        );
                        final nextDate = DateTime(
                          nextMessage.createdAt.year,
                          nextMessage.createdAt.month,
                          nextMessage.createdAt.day,
                        );
                        showDateSeparator = currentDate != nextDate;
                      }
                      final previousMessage = index > 0 ? messages[index - 1] : null;
                      final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;
                      final isFirstInGroup = previousMessage == null || previousMessage.senderId != message.senderId;
                      final isLastInGroup = nextMessage == null || nextMessage.senderId != message.senderId;
                      final currentUid = FirebaseAuth.instance.currentUser!.uid;

                      final isLastMyMessage = message.senderId == currentUid && messages
                          .where((m) => m.senderId == currentUid)
                          .last
                          .id == message.id;
                      return Column(
                        children: [
                          if (showDateSeparator)
                            DateSeparator(text: getDateLabel(message.createdAt,),),
                          MessageBubble(
                            text: message.text,
                            isMe: message.senderId == currentUid,
                            createdAt: message.createdAt,
                            readBy: message.readBy,
                            isFirstInGroup: isFirstInGroup,
                            isLastInGroup: isLastInGroup,
                            showReadReceipt: isLastMyMessage,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: 'Type a message...',),
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      final text = _messageController.text;
                      if (text.trim().isEmpty) return;
                      _messageController.clear();
                      await context.read<ChatProvider>().sendMessage(
                        receiverId: widget.receiverId,
                        text: text,
                      );
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final yesterday = today.subtract(
      const Duration(days: 1),
    );
    final messageDate = DateTime(
      date.year,
      date.month,
      date.day,
    );
    if (messageDate == today) {
      return 'Today';
    }
    if (messageDate == yesterday) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
