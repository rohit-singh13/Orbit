import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/widgets/background_widget.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Column(
            children: [
              SizedBox(height: 20,),

              SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search Orbiters...",
                          prefixIcon: Icon(Icons.search)
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                    ),
                  ),
              ),
              Center(
                child: Text("World Exploring coming soon"),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigation(
          currentIndex: 4,
          onTap: (index) {
            if(index == 4) return;
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
