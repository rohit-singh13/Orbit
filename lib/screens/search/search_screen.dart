import 'package:flutter/material.dart';
import 'package:orbit/providers/search_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Orbiters...",
                      prefixIcon: Icon(Icons.search)
                    ),
                    onChanged: (value) {
                      context.read<SearchProvider>()
                          .searchUsers(value);
                    },
                  ),
                ),
                SizedBox(height: 16,),
                Expanded(
                    child: Consumer<SearchProvider>(
                      builder: (context, provider, child)
                      {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: provider.results.length,
                            itemBuilder: (context, index) {
                            final user = provider.results[index];
                            if (provider.results.isEmpty) {
                              return const Center(
                                child: Text("No users found"),
                              );
                            }
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.bio ?? ""),
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.userProfile, arguments: user.uid);
                              },
                            );
                            });
                      }
                    ))
              ],
            ),
          )),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
