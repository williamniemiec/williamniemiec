import 'package:flutter/material.dart';
import 'package:aegis_vault/utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: kBodyStyle,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: kSubtitleStyle,
        prefixIcon: icon != null ? Icon(icon, color: kAccentColor) : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kAccentColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kSecondaryColor),
        ),
      ),
    );
  }
}