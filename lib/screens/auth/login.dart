import 'package:flutter/material.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';

class Login extends StatefulWidget{
  const Login ({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: AppBackground(
          child: Center(
            child: AuthCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/logo/logo.png", height: 150, width: 150,),

                        Text("Welcome back to your Orbit", style: TextStyle(fontSize: 25),),

                        SizedBox(height: 50,),

                        CustomTextField(
                            labelText: "Email or Username",
                        ),

                        SizedBox(height: 10,),

                        CustomTextField(
                            labelText: "Password",
                        ),

                        SizedBox(height: 30,),

                        CustomButton(
                            text: "Login",
                            onPressed: (){}
                        ),

                        SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .dividerColor,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .hintColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .dividerColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        OutlinedButton(
                            onPressed: (){},
                            child: Text("Continue with Google")),
                      ],
                    ),
                  ),
                )),
          )),
    );
  }

}
