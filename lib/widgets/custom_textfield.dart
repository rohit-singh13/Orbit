import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength
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
        maxLines: maxLines,
        maxLength: maxLength
    );
  }
}