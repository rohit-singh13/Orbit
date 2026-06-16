import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendProvider>()
          .loadFriends(
        FirebaseAuth.instance
            .currentUser!
            .uid
      );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Consumer<FriendProvider>(
            builder: (context, provider, child) {
              if (provider.friends.isEmpty) {
                return const Center(
                  child: Text(
                    "No friends yet",
                  ),
                );
              }
              return ListView.builder(
                itemCount: provider.friends.length,
                  itemBuilder: (context, index) {
                  final friend = provider.friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend.imageUrl != null ? NetworkImage(friend.imageUrl!) : null,
                    ),
                    title: Text(friend.name),
                    subtitle: Text(friend.bio ?? "No bio yet"),
                  );
                  }
              );
            }
        ),
      ),
    );
  }
}
