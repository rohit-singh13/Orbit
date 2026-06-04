import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/auth_card.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:orbit/providers/auth_provider.dart' as Orbit;


class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<Orbit.AuthProvider>();
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
                        Icon(Icons.mark_email_read, size: 80),
                        
                        SizedBox(height: 10,),
                        
                        Text("Verify Your Email"),
                        
                        SizedBox(height: 10,),
                        
                        Text("We have sent a Verification link to "),

                        Text(
                          FirebaseAuth.instance.currentUser?.email ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text("\nPlease open the email and click the verfication link."),
                        
                        SizedBox(height: 10,),
                        
                        CustomButton(
                            onPressed: authProvider.isLoading? null : () async {
                              final verified = await authProvider.checkEmailVerification();

                              if(!mounted) return;
                              if(verified) {
                                Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.home);
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Your Email is not verified Yet"),
                                    ));
                              }

                            },
                            text: authProvider.isLoading ? "Verifying..." : "I've Verified",
                        ),

                        SizedBox(height: 10,),

                        TextButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            await authProvider.sendVerificationEmail();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Verification email sent",
                                ),
                              ),
                            );
                          },
                          child: const Text("Resend Email"),
                        ),

                      ],
                    )
                  ),
                ),
              )
          ),
        ),
    );
  }
}
