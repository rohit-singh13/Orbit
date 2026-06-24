import 'package:flutter/material.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/story_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/widgets/friend_story_grid.dart';
import 'package:orbit/widgets/my_story_widget.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user!;
    final friends = context.watch<FriendProvider>().friends;
    return Scaffold(
      appBar: AppBar(
        title: Text("Orbit"),
      ),
      body: AppBackground(
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40,),

                    StreamBuilder<List<StoryModel>>(
                        stream: StoryServices().streamUserStories(
                        currentUser.uid
                        ),
                        builder: (context, snapshot) {
                          return MyStoryWidget(
                              imageUrl: currentUser.imageUrl,
                              stories: snapshot.data ?? []
                          );
                        }),

                    const SizedBox(height: 30,),

                    FriendStoryGrid(friends: friends)
                  ],
                ),
              ))),
      bottomNavigationBar: BottomNavigation(
          currentIndex: 0,
          onTap: (index) {
            if(index == 0) return;
            switch(index) {
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
          }),
    );
  }
}
