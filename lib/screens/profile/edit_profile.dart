import 'package:flutter/material.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/services/media_picker.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController gen = TextEditingController();
  TextEditingController pronounce = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final imagePath = context.watch<UserProvider>().imagePath;
    return Scaffold(
      body: AppBackground(
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back)),

                      Text("Edit Profile")
                    ],
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 70),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await MediaPicker().pickImage(
                                  context.read<UserProvider>(),
                                );
                              },
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
                                child: imagePath == null ? const Icon(Icons.person, size: 80) : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          CustomTextField(
                            validator: (val) => val!.isEmpty? "Name is Required" : null,
                              labelText: "Username",
                            controller: name,
                          ),

                          SizedBox(height: 10,),

                          CustomTextField(
                            validator: (val) => val!.isEmpty? "Bio can't be Empty" : null,
                              labelText: "Bio",
                            controller: bio,
                          ),

                          SizedBox(height: 10,),

                          // dropdown for gender selection
                          // dropdown for pronounce selection

                          CustomButton(
                              text: "Confirm",
                              onPressed: (){})
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  @override
  void dispose() {
    name.dispose();
    bio.dispose();
    gen.dispose();
    pronounce.dispose();
    super.dispose();
  }
}
