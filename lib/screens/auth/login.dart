import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'package:orbit/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget{
  const Login ({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isHidden = true;
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

                          Text("Welcome back to your Orbit", style: TextStyle(fontSize: 25),),

                          SizedBox(height: 50,),

                          CustomTextField(
                              labelText: "Email",
                            controller: email,
                            validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                if(!value.contains('@')) {
                                  return "Invalid email";
                                }
                                return null;
                            },
                          ),

                          SizedBox(height: 10,),

                          CustomTextField(
                              labelText: "Password",
                            controller: password,
                            obscureText: _isHidden,
                            validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Password is required";
                                }
                                if(value.length < 8) {
                                  return "Password is short";
                                }
                                return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isHidden? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                            ),
                          ),

                          TextButton(onPressed: (){
                            Navigator.pushNamed(
                                context,
                                AppRoutes.forgotPassword);
                          },
                              child: const Text("Forgot Password?")),

                          SizedBox(height: 30,),

                          CustomButton(
                              backgroundColor: const Color(0xff06B6D4),
                              text: authProvider.isLoading? "Logging In..." : "Login",
                              onPressed: authProvider.isLoading? null : () async{
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final provider = context.read<AuthProvider>();
                                await provider.signIn(email: email.text.trim(), password: password.text.trim());
                                if(!mounted) return;
                                if (provider.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(provider.error!),
                                    ),
                                  );
                                  return;
                                }
                                if(provider.error == null ) {
                                  Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.home);
                                }
                              }
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
                  ),
                )),
          )),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

}
