import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orbit/models/post_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/post_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/widgets/post_grid.dart';
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
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.createPost,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.friendRequest);
                              }, icon: Icon(Icons.notifications, size: 30,)),
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
                            textAlign: TextAlign.center,
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
                          StreamBuilder(
                              stream: PostServices().streamUserPosts(user!.uid),
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return _statItem(count.toString(), "Posts");
                              }),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.friendsList);
                            },
                            child: _statItem(user?.friendsCount.toString() ?? "0", "Friends"),
                          )

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<PostModel>>(
                        stream: PostServices().streamUserPosts(user!.uid),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return PostGrid(posts: snapshot.data!);
                        })
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

            if(index == 2) {
              context.read<UserProvider>().refreshUser();
              return;
            }

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
