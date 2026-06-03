import 'package:flutter/material.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:orbit/providers/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final _formKey = GlobalKey<FormState>();
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
                        children: [
                          Icon(Icons.shield_outlined, size: 80,),

                          SizedBox(height: 20,),

                          Text("Need help with Login?", style: TextStyle(fontSize: 24),),

                          SizedBox(height: 10,),

                          Text("Enter your email and we'll send you a link to get back into your Orbit", style: TextStyle(fontSize: 18),),

                          SizedBox(height: 20,),

                          CustomTextField(
                              labelText: "Email",
                            controller: email,
                            validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                if(!value.contains('@')) {
                                  return "Email is invalid";
                                }
                                return null;
                            },
                          ),

                          SizedBox(height: 10,),

                          CustomButton(text: authProvider.isLoading?
                              "Sending..." : "Send Reset Link",
                              onPressed: authProvider.isLoading?
                                  null : () async {
                            if(!_formKey.currentState!.validate()) {
                              return;
                            }
                            final provider = context.read<AuthProvider>();

                            await provider.forgotPassword(
                              email.text.trim(),
                            );

                            if(!mounted) return;

                            if(provider.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.error!),
                                  ),);
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Password reset email sent"),
                                ));
                              }
                              )

                        ],
                      ),
                    ),
                ),
                ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}
