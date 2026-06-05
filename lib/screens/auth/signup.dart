import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:orbit/providers/auth_provider.dart';

class Signup extends StatefulWidget{
  const Signup ({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup>{
  bool _isPasswordHidden = true;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    final authProvider = context.watch<AuthProvider>();
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
                          Image.asset("assets/logo/logo.png", height: 150, width: 150,),

                          Text("Your people. Your space. Your orbit.", style: TextStyle(fontSize: 25),),

                          SizedBox(height: 50,),

                          CustomTextField(
                              labelText: "Username",
                              controller: name,
                            validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Username is required";
                                }
                                return null;
                            },
                          ),

                          SizedBox(height: 10,),

                          CustomTextField(
                              labelText: "Email",
                            controller: email,
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return "Invalid email";
                                }
                                return null;
                            },
                          ),

                          SizedBox(height: 10,),

                          CustomTextField(
                            labelText: "Password",
                            controller: password,
                            obscureText: _isPasswordHidden,
                            suffixIcon: IconButton(
                              icon: Icon( _isPasswordHidden ? Icons.visibility_off : Icons.visibility,),
                              onPressed: () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 8) {
                                return "Minimum 8 characters";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 30,),

                          CustomButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final provider = context.read<AuthProvider>();

                              await provider.signUp(
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );

                              if (provider.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.error!),
                                  ),
                                );
                                return;
                              }

                              Navigator.pushNamed(
                                  context,
                                  AppRoutes.emailVerification);
                            },
                            text: authProvider.isLoading? "Creating Account..." : "Sign Up",

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
                              onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                final provider = context.read<AuthProvider>();
                                await provider.signInWithGoogle();
                                if(!mounted) return;
                                if (provider.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(
                                        content: Text(provider.error!),
                                      ), );
                                  return;
                                }
                                Navigator.pushReplacementNamed(
                                    context,
                                AppRoutes.home);
                              },
                              child: Text("Continue with Google")),
                        ],
                      ),
                    ),
                  ),
                )),
          )),
    );
  }

  @override
  void dispose(){
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

}
