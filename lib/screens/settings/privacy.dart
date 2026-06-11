import 'package:flutter/material.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/setting_tile.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool isPrivateAccount = false;
  String whoCanAddMe = "Everyone";
  String whoCanMessageMe = "Everyone";
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
                          "Privacy",
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
                    SettingsTile(
                      icon: Icons.privacy_tip,
                      title: "Private Account",
                      iconColor: Colors.teal.shade500,
                      trailing: Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: isPrivateAccount,
                          onChanged: (value) {
                            setState(() {
                              isPrivateAccount = value;
                            });
                          },
                        ),
                      ),
                      onTap: () {},
                    ), // here a switch

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.person_add_rounded,
                        title: "Who can add me",
                        iconColor: Colors.blue.shade400,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Everyone"),
                                    onTap: () {
                                      setState(() => whoCanAddMe = "Everyone");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Friends of Friends"),
                                    onTap: () {
                                      setState(() => whoCanAddMe = "Friends of Friends");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Nobody"),
                                    onTap: () {
                                      setState(() => whoCanAddMe = "Nobody");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      trailing: Text(whoCanAddMe),
                        ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.message,
                        title: "Who can message me",
                        iconColor: Colors.indigo.shade400,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Everyone"),
                                    onTap: () {
                                      setState(() => whoCanMessageMe = "Everyone");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Friends"),
                                    onTap: () {
                                      setState(() => whoCanMessageMe = "Friends");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Nobody"),
                                    onTap: () {
                                      setState(() => whoCanMessageMe = "Nobody");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      trailing: Text(whoCanMessageMe),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.block,
                        title: "Blocked User",
                        iconColor: Colors.red.shade400,
                        onTap: () {
                        } ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
