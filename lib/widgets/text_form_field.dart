import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsecured = false,
    this.onFieldSubmitted,
  });

  String hintText;
  TextEditingController controller;
  bool isObsecured;
  void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecured,
      textInputAction: TextInputAction.next,
      scribbleEnabled: true,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
