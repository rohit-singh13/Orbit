import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendProvider>()
          .loadIncomingRequests(
        FirebaseAuth.instance
            .currentUser!
            .uid
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FriendProvider>(builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.incomingRequests.length,
            itemBuilder: (context, index) {
            final request = provider.incomingRequests[index];
            return ListTile(
              title: Text(request.senderId),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () async {
                    await context.read<FriendProvider>().acceptRequest(request.id, FirebaseAuth.instance.currentUser!.uid);
                  },
                      icon: Icon(Icons.check)),
                  IconButton(onPressed: () async {
                    await context.read<FriendProvider>().rejectRequest(request.id, FirebaseAuth.instance.currentUser!.uid);
                  }, icon: Icon(Icons.close))
                ],
              ),
            );
            }
        );
      }),
    );
  }
}
