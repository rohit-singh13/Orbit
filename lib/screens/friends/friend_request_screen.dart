import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:orbit/widgets/background_widget.dart';
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
      body: AppBackground(
        child: Consumer<FriendProvider>(builder: (context, provider, child) {
          if (provider.incomingRequests.isEmpty) {
            return const Center(
              child: Text(
                "No friends yet",
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.incomingRequests.length,
              itemBuilder: (context, index) {
              final request = provider.incomingRequests[index];
              return FutureBuilder(
                  future: FirestoreServices().getUser(request.senderId),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return const ListTile(
                        title: Text("Loading..."),
                      );
                    }
                    final sender = snapshot.data!;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: sender.imageUrl != null ? NetworkImage(sender.imageUrl!) : null,
                      ),
                      title: Text(sender.name),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await context.read<FriendProvider>()
                                    .acceptRequest(request.id, FirebaseAuth.instance.currentUser!.uid,
                                );
                              }, child: Text("Accept")),
                          TextButton(
                              onPressed: () async {
                                await context.read<FriendProvider>()
                                    .rejectRequest(request.id, FirebaseAuth.instance.currentUser!.uid);
                              }, child: Text("Reject"))
                        ],
                      ),
                    );
                  });
              }
          );
        }),
      ),
    );
  }
}
