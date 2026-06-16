import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/setting_tile.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool isPrivateAccount = false;
  String whoCanCallMe = "Everyone";
  String whoCanMessageMe = "Everyone";

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final user = await FirestoreServices()
        .getUser(FirebaseAuth.instance.currentUser!.uid);

    if (user == null) return;

    setState(() {
      isPrivateAccount = user.privateAccount;
      whoCanCallMe = user.whoCanCallMe;
      whoCanMessageMe = user.whoCanMessageMe;
    });
  }
  Future<void> _savePrivacySettings() async {
    await FirestoreServices().updatePrivacySettings(
      uid: FirebaseAuth.instance.currentUser!.uid,
      privateAccount: isPrivateAccount,
      whoCanCallMe: whoCanCallMe,
      whoCanMessageMe: whoCanMessageMe,
    );
  }

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
                          "Privacy Settings",
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
                          onChanged: (value) async {
                            setState(() {
                              isPrivateAccount = value;
                            });
                            await _savePrivacySettings();
                          },
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 56),
                      child: Divider(
                        thickness: 0.7,
                        height: 10,
                      ),
                    ),

                    SettingsTile(
                        icon: Icons.person_add_rounded,
                        title: "Who can call me",
                        iconColor: Colors.blue.shade400,
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (sheetContext) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Everyone"),
                                    onTap: () async {
                                      setState(() => whoCanCallMe = "Everyone");
                                      await _savePrivacySettings();
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Friends"),
                                    onTap: () async {
                                      setState(() => whoCanCallMe = "Friends");
                                      await FirestoreServices().updatePrivacySettings(
                                          uid: FirebaseAuth.instance.currentUser!.uid,
                                          privateAccount: isPrivateAccount,
                                          whoCanCallMe: whoCanCallMe,
                                          whoCanMessageMe: whoCanMessageMe
                                      );
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Nobody"),
                                    onTap: () async {
                                      setState(() => whoCanCallMe = "Nobody");
                                      await _savePrivacySettings();
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      trailing: Text(whoCanCallMe),
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
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (sheetContext) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Everyone"),
                                    onTap: () async {
                                      setState(() => whoCanMessageMe = "Everyone");
                                      await _savePrivacySettings();
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Friends"),
                                    onTap: () async {
                                      setState(() => whoCanMessageMe = "Friends");
                                      await _savePrivacySettings();
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Nobody"),
                                    onTap: () async {
                                      setState(() => whoCanMessageMe = "Nobody");
                                      await _savePrivacySettings();
                                      Navigator.pop(sheetContext);
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
