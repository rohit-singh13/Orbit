import 'package:flutter/material.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/widgets/background_widget.dart';
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
    Future.microtask(() {
      context.read<ChatProvider>().listenMessages(widget.receiverId);
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
                      final currentUid = FirebaseAuth.instance.currentUser!.uid;
                      return MessageBubble(
                          text: message.text,
                          isMe: message.senderId == currentUid,
                          createdAt: message.createdAt);
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
