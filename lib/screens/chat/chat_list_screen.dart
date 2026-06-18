import 'package:flutter/material.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/widgets/chat_tile.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatProvider>().listenChats();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: AppBackground(
        child: Consumer<ChatProvider>(
            builder: (context, provider, child) {
              if(provider.chats.isEmpty) {
                return const Center(
                  child: Text("No chats yet"),
                );
              }

              return ListView.builder(
                itemCount: provider.chats.length,
                  itemBuilder: (context, index) {
                  final chat = provider.chats[index];
                  return ChatTile(
                      chat: chat,
                      onTap: () {}
                  );
                  });
            }
        ),
          ),
      bottomNavigationBar: BottomNavigation(
          currentIndex: 1,
          onTap: (index) {

            if(index == 1) return;

            switch(index){

              case 0:
                Navigator.pushReplacementNamed(context, AppRoutes.home);
                break;

              case 1:
                Navigator.pushReplacementNamed(context, AppRoutes.chatList);
                break;

              case 2:
                Navigator.pushReplacementNamed(context, AppRoutes.profile);
                break;

              case 3:
                Navigator.pushReplacementNamed(context, AppRoutes.signal);
                break;

              case 4:
                Navigator.pushReplacementNamed(context, AppRoutes.explore);
                break;
            }
          }
          ),
    );
  }
}
