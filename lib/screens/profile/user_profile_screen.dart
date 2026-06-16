import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:orbit/services/friend_services.dart';
import 'package:orbit/widgets/background_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoaded = false;
  Future<UserModel?>? _userFuture;
  Future<FriendStatus>? _friendStatusFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isLoaded) return;
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    _userFuture = FirestoreServices().getUser(uid);
    _friendStatusFuture = FriendServices().getFriendStatus(currentUserId: FirebaseAuth.instance.currentUser!.uid, targetUserId: uid);
    _isLoaded = true;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
        child: CircularProgressIndicator(),
    );
        }
        if (!snapshot.hasData) {
          return const Center(
          child: Text("User not found"),
          );
    }
        final user = snapshot.data!;
        return Scaffold(
          body: AppBackground(
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back)),
                          Text(user.name)
                        ],
                      )),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
                              child: user.imageUrl == null ? const Icon(Icons.person, size: 60,) : null,
                            ),
                            SizedBox(height: 15,),
                            Text(user.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,)),
                            SizedBox(height: 10,),
                            Text("${user.gender ?? ""} • ${user.pronouns ?? ""}"),
                            SizedBox(height: 15,),
                            Text(user.bio ?? "No bio yet"),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _statItem(
                                  "0",
                                  "Posts",
                                ),

                                _statItem(
                                  user.friendsCount.toString(),
                                  "Friends",
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            FutureBuilder<FriendStatus>(
                                future: _friendStatusFuture,
                                builder: ((context, snapshot) {
                                  if(!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final status = snapshot.data!;
                                  final canViewPosts = !user.privateAccount || status == FriendStatus.friends;
                                  return Column(
                                    children: [
                                      switch(status) {
                                      FriendStatus.none =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Add Friend")),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Request Message"))
                                            ],
                                          ),
                                      FriendStatus.pendingIncoming =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Accept")),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Reject"))
                                            ],
                                          ),
                                      FriendStatus.pendingOutgoing =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: null,
                                                  child: Text("Request Sent")),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Cancel Request"))
                                            ],
                                          ),
                                      FriendStatus.friends =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Message")),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Remove Friend"))
                                            ],
                                          )
                                      },
                                      SizedBox(height: 20,),
                                      if (!canViewPosts)
                                        Column(
                                          children: [
                                            Icon(Icons.lock, size: 40,),
                                            SizedBox(height: 10,),
                                            Text("This account is private")
                                          ],
                                        )
                                      else
                                        Column(
                                          children: [
                                            Text("No posts yet")
                                          ],
                                        )
                                    ],
                                  );
                                  

                                }),

                            ),


                          ],
                        ),
                      ),
                    ),
                  )
                ],

              )
          ),
          bottomNavigationBar: BottomNavigation(
              currentIndex: 2,
              onTap: (index) {

                if(index == 2) return;

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
    );
  }
  Widget _statItem(
      String count,
      String label,
      ) {
    return Column(
      children: [
        Text(count, style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
