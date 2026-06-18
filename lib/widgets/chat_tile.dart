import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/chat_model.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final otherUid = chat.participants.firstWhere((uid) => uid != currentUid);
    final unreadCount = chat.unreadCounts[currentUid] ?? 0;
    return FutureBuilder<UserModel?>(
        future: FirestoreServices().getUser(otherUid),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const SizedBox();
          }
          final user = snapshot.data!;
          return ListTile(
            onTap: () async {
              await Navigator.pushNamed(
                  context, 
                  AppRoutes.personalChat,
                arguments: {
                    'receiverId': user.uid,
                  'receiverName': user.name,
                  'receiverImageUrl': user.imageUrl
                }
              );
              if(!context.mounted) return;
              context.read<ChatProvider>().listenChats();
            },
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
              child: user.imageUrl == null ? const Icon(Icons.person) : null,
            ),
            title: Row(
              children: [
                Expanded(
                    child: Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis,)
                ),
                Text(formatChatTime(chat.lastMessageTime), style: TextStyle(fontSize: 12, color: Colors.grey),)
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(child: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                if(unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                    child: Text(unreadCount.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                  )
              ],
            ),
          );
        }
    );
  }
}

String formatChatTime(DateTime? time) {
  if(time == null) return '';
  final displayHour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$displayHour:$minute $period';
}
