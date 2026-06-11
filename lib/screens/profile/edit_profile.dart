import 'package:flutter/material.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/services/cloudinary_service.dart';
import 'package:orbit/services/firestore_services.dart';
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
  String? selectedGender;
  String? selectedPronoun;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if(user != null) {
      name.text = user.name;
      bio.text = user.bio ?? '';
      selectedGender = user.gender;
      selectedPronoun = user.pronouns;
    }
  }

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
                            maxLines: 3,
                            maxLength: 150,
                          ),

                          SizedBox(height: 10,),

                         DropdownButtonFormField<String>(
                           initialValue: selectedGender,
                             decoration: const InputDecoration(
                               labelText: "Gender",
                             ),
                             items: const [
                               DropdownMenuItem(
                                   value: "Male",
                                   child: Text("Male")),
                               DropdownMenuItem(
                                 value: "Female",
                                   child: Text("Female")),
                               DropdownMenuItem(
                                 value: "Other",
                                   child: Text("Other"))
                             ], onChanged: (value) {
                             setState(() {
                               selectedGender = value;
                             });
                         },
                           validator: (value) => value == null ? "Please select a gender" : null,
                         ),

                          SizedBox(height: 10,),

                          DropdownButtonFormField<String>(
                            initialValue: selectedPronoun,
                              decoration: const InputDecoration(
                                labelText: "Pronouns"
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "He/Him",
                                    child: Text("He/Him")),
                                DropdownMenuItem(
                                  value: "She/Her",
                                    child: Text("She/Her")),
                                DropdownMenuItem(
                                  value: "They/Them",
                                    child: Text("They/Them")),
                                DropdownMenuItem(
                                  value: "Prefer not to say",
                                    child: Text("Prefer Not to Say")),
                              ], onChanged: (value) {
                              setState(() {
                                selectedPronoun = value;
                              });
                          },
                            validator: (value) => value == null ? "Please select your pronouns" : null,
                          ),

                          SizedBox(height: 10,),

                          CustomButton(
                              text: "Confirm",
                              onPressed: () async {
                                if(!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final userProvider = context.read<UserProvider>();
                                final currentUser = userProvider.user;
                                if(currentUser == null) return;
                                final imagePath = userProvider.imagePath;
                                String? imageUrl = currentUser.imageUrl;
                                if(imagePath != null) {
                                  imageUrl = await CloudinaryService().uploadImage(imagePath);
                                }
                                await FirestoreServices().updateUser(
                                    currentUser.uid,
                                    {
                                      "name": name.text.trim(),
                                      "bio": bio.text.trim(),
                                      "gender": selectedGender,
                                      "pronouns": selectedPronoun,
                                      "imageUrl": imageUrl,
                                    },
                                );
                                await userProvider.loadUser(currentUser.uid);
                                if(!mounted) return;
                                Navigator.pop(context);
                              })
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
    super.dispose();
  }
}
