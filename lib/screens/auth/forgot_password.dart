import 'package:flutter/material.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Center(
            child: AuthCard(
                child: Padding(
                    padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.shield_outlined, size: 80,),

                        SizedBox(height: 20,),

                        Text("Need help with Login?", style: TextStyle(fontSize: 24),),
                        
                        SizedBox(height: 10,),
                        
                        Text("Enter your email or username and we'll send you a link to get back into your Orbit", style: TextStyle(fontSize: 18),),

                        SizedBox(height: 20,),

                        CustomTextField(labelText: "Email or Username"),

                        SizedBox(height: 10,),

                        CustomButton(text: "Send Link", onPressed: (){})

                      ],
                    ),
                ),
                ),
            ),
          )),
    );
  }
}
