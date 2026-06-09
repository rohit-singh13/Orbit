import 'package:flutter/material.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  String? tempBio;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.editProfile);
          },
        child: Icon(Icons.edit),
          ),
      body: AppBackground(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 70,
                    child: Icon(Icons.person, color: Colors.white, size: 80,),
                  ),
                  SizedBox(height: 10,),
                  Text(user?.name ?? "Loading..."),
                  SizedBox(height: 10,),
                  Text("Your Bio Here"),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: Divider(),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _navItem(Icons.auto_awesome, "Posts", 0),
                        SizedBox(width: 50,),
                        _navItem(Icons.people_alt_outlined, "Followers", 1),
                        SizedBox(width: 55,),
                        _navItem(Icons.people, "Following", 2),

                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Divider(),
                  ),
                  Text("Here the all the posts or videos of the user will show")
                ],
              ),
            ),
          )),
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
  Widget _navItem(IconData icons, String label, int index ) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icons),
          Text(label),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
