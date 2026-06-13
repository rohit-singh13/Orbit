import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/friend_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final imagePath = context.watch<UserProvider>().imagePath;
    return Scaffold(
      body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                          icon: const Icon(Icons.settings, size: 30,),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.settings);
                          },
                        ),
                        ],
                ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                      imagePath != null
                          ? FileImage(File(imagePath))
                          : user?.imageUrl != null
                          ? NetworkImage(user!.imageUrl!)
                          : null,
                      child: imagePath == null && user?.imageUrl == null
                          ? const Icon(Icons.person, size: 90)
                          : null,
                    ),
                    SizedBox(height: 15,),
                    Text(user?.name ?? "Loading...", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: 8,),
                    Text("${user?.gender ?? ""} • ${user?.pronouns ?? ""}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ReadMoreText(user?.bio?.isNotEmpty == true ? user!.bio! : "Go to Edit Profile to write your Bio",
                            style: TextStyle(fontSize: 15, height: 1.4),
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...see more',
                          trimExpandedText: '\nshow less',
                        ),
                      ),
                    SizedBox(height: 25,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statItem("0", "Posts"),
                          _statItem("0", "Followers"),
                          _statItem("0", "Following")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 80,
                        ),
                        SizedBox(height: 15),
                        Text("No Posts Yet"),
                      ],
                    ),
                    // temporary code
                    ElevatedButton(
                      onPressed: () async {
                        await FriendServices()
                            .sendFriendRequest(
                          senderId: "AgDBdfBidQRnNxYxqD9wXOIds7w1",
                          receiverId: "tlhiZ1fu8JNJW2ie0EKbNxtr4uy2",
                        );
                      },
                      child: const Text(
                        "Send Request",
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {

                        await FriendServices()
                            .acceptRequest(
                          requestId:
                          "XadCabX7iS7ljZiYhSUz",
                        );

                      },
                      child: const Text(
                        "Accept Request",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await context
                            .read<FriendProvider>()
                            .loadIncomingRequests(
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                      },
                      child: const Text(
                        "Load Requests",
                      ),
                    ),

                    Consumer<FriendProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          "Incoming Requests: ${provider.incomingRequests.length}",
                        );
                      },
                    ),
                  ],
                ),
            ),
            ],
          ),
          ),
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
  Widget _statItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        Text(label),
      ],
    );
  }
}
