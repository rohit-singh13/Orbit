import 'package:flutter/material.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/services/chat_services.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/date_separator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbit/widgets/message_bubble.dart';
import 'package:orbit/models/chat_model.dart';

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
  bool _isTyping = false;


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

            Expanded(
              child: StreamBuilder(
                stream: FirestoreServices().streamUser(
                  widget.receiverId,
                ),
                builder: (context, userSnapshot) {
                  final user = userSnapshot.data;
                  return StreamBuilder<ChatModel?>(
                    stream: ChatServices().streamChat(widget.receiverId,),
                    builder: (context, chatSnapshot) {
                      String statusText = "Offline";
                      final chat = chatSnapshot.data;
                      final otherTyping = chat?.typingUsers.contains(widget.receiverId,) ?? false;
                      if (otherTyping) {
                        statusText = "Typing...";
                      } else if (user != null) {
                        if (user.isOnline) {
                          statusText = "Active now";
                        } else if (user.lastSeen != null) {
                          statusText =
                          "Last seen ${formatLastSeen(user.lastSeen!)}";
                        }
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
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
                      onChanged: (value) async {
                        if(value.trim().isNotEmpty && !_isTyping) {
                          _isTyping = true;
                          await context.read<ChatProvider>()
                              .setTypingStatus(otherUserId: widget.receiverId, isTyping: true);
                        }
                        if(value.trim().isEmpty && _isTyping) {
                          _isTyping = false;
                          await context.read<ChatProvider>()
                              .setTypingStatus(otherUserId: widget.receiverId, isTyping: false);
                        }
                      },
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      final text = _messageController.text;
                      if (text.trim().isEmpty) return;
                      _messageController.clear();
                      if(_isTyping) {
                        _isTyping = false;
                        await context.read<ChatProvider>()
                            .setTypingStatus(otherUserId: widget.receiverId, isTyping: false);
                      }
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

  String formatLastSeen(
      DateTime time,
      ) {
    final diff = DateTime.now().difference(time);
    if(diff.inMinutes < 1) {
      return "just now";
    }
    if(diff.inHours < 1) {
      return "${diff.inMinutes}m ago";
    }
    if(diff.inDays < 1) {
      return "${diff.inHours}h ago";
    }
    return "${diff.inDays}d ago";
  }

  @override
  void dispose() {
    if(_isTyping) {
      context.read<ChatProvider>().setTypingStatus(otherUserId: widget.receiverId, isTyping: false);
    }
    _messageController.dispose();
    super.dispose();
  }
}
