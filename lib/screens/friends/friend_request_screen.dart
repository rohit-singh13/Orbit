import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  String? _loadingRequestId;

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
                "No friends requests",
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
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.userProfile, arguments: sender.uid);
                        },
                        child: CircleAvatar(
                          backgroundImage: sender.imageUrl != null ? NetworkImage(sender.imageUrl!) : null,
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.userProfile, arguments: sender.uid);
                        },
                        child: Text(sender.name),
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                              onPressed: _loadingRequestId != null ? null : () async {
                                setState(() {
                                  _loadingRequestId = request.id;
                                });
                                try {
                                  await context.read<FriendProvider>()
                                      .acceptRequest(request.id, FirebaseAuth.instance.currentUser!.uid,
                                  );
                                } finally {
                                  setState(() {
                                    _loadingRequestId = null;
                                  });
                                }
                              }, child: _loadingRequestId == request.id ? SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ) :  Text("Accept")),
                          IconButton(
                              onPressed: _loadingRequestId != null ? null : () async {
                                setState(() {
                                  _loadingRequestId = request.id;
                                });
                                try {
                                  await context.read<FriendProvider>()
                                      .rejectRequest(request.id, FirebaseAuth.instance.currentUser!.uid);
                                } finally {
                                  setState(() {
                                    _loadingRequestId = null;
                                  });
                                }
                              }, icon: _loadingRequestId == request.id ? SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ) : Icon(Icons.close))
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
