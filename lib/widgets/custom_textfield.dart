import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}