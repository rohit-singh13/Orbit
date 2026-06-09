import 'package:flutter/material.dart';
import 'package:orbit/widgets/background_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Text("Edit Profile coming soon")),
    );
  }
}
