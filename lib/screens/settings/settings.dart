import 'package:flutter/material.dart';
import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/providers/search_provider.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/section_title.dart';
import 'package:orbit/widgets/setting_tile.dart';
import 'package:orbit/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:orbit/providers/user_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Column(
            children: [
              SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back)),
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        )
                      ],
                    ),
                  )),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SectionTitle(title: "Account settings"),
                    SettingsTile(
                        icon: Icons.person,
                        title: "Edit Profile",
                        iconColor: Colors.blue.shade400,
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              AppRoutes.editProfile);
                        }),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.lock,
                        title: "Privacy",
                        iconColor: Colors.teal.shade500,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.privacy);
                        }),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SectionTitle(title: "App settings"),

                    SettingsTile(
                        icon: Icons.brightness_auto,
                        title: "Theme",
                        iconColor: Colors.deepPurple.shade400,
                        onTap: () {}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.notifications,
                        title: "Notification",
                        iconColor: Colors.amber.shade700,
                        onTap: () {}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SectionTitle(title: "Support"),

                    SettingsTile(
                        icon: Icons.info,
                        title: "About Us",
                        iconColor: Colors.indigo.shade400,
                        onTap: () {}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.support_agent,
                        title: "Help & Support",
                        iconColor: Colors.cyan.shade500,
                        onTap: () {}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SectionTitle(title: "Account actions"),

                    SettingsTile(
                        icon: Icons.logout,
                        title: "Logout",
                        iconColor: Colors.orange.shade600,
                        onTap: () async {
                          await context.read<UserProvider>().updateOnlineStatus(false);
                          context.read<UserProvider>().clearUser();
                          context.read<SearchProvider>().clearSearch();
                          await context.read<ChatProvider>().clearTypingStatus();
                          context.read<ChatProvider>().clearChat();
                          await context.read<AuthProvider>().signOut();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.intro,
                              (route) => false
                          );
                        } ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.delete,
                        title: "Delete Account",
                        iconColor: Colors.red.shade400,
                        onTap: () {}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
