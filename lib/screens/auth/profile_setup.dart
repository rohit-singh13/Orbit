import 'package:flutter/material.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'package:orbit/utils/date_time_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbit/services/firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:orbit/providers/user_provider.dart';


class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> selectDOB() async {

    final pickedDate =
    await DateTimeHelper.pickDate(context);

    if (pickedDate != null) {

      dob.text =
      "${pickedDate.day}/"
          "${pickedDate.month}/"
          "${pickedDate.year}";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Center(
            child: AuthCard(
                child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Set up your Orbit", style: TextStyle(fontSize: 25),),

                          SizedBox(height: 20,),

                          CustomTextField(
                              labelText: "Username",
                            controller: name,
                            validator: (val) => val!.isEmpty ? "Name is required" : null,
                          ),

                          SizedBox(height: 10,),

                          TextField(
                            controller: dob,
                            readOnly: true,
                            onTap: selectDOB,
                            decoration: InputDecoration(
                              labelText: "Date of Birth",
                              suffixIcon: Icon(Icons.calendar_month),
                            ),
                          ),

                          SizedBox(height: 20,),

                          CustomButton(
                              text: "Create my Orbit",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final user = UserModel(
                                      uid: FirebaseAuth.instance.currentUser!.uid,
                                      name: name.text.trim(),
                                      nameLower: name.text.trim().toLowerCase(),
                                      email: FirebaseAuth.instance.currentUser!.email!,
                                      createdAt: DateTime.now(),
                                      privateAccount: false,
                                      friendsCount: 0,
                                      requestsCount: 0
                                    );
                                    await FirestoreServices().createUser(user);
                                    context.read<UserProvider>().setUser(user);
                                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Something went wrong: $e")),
                                    );
                                  }
                                }
                              }
                                )



                        ],
                      ),
                    ),
                ),
                )
            ),
          )),
    );
  }

  @override
  void dispose() {
    name.dispose();
    dob.dispose();
    super.dispose();
  }
}
