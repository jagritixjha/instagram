import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.isPassword = false,
  });

  String hintText;
  TextEditingController controller;
  bool obscureText;
  bool isPassword;

  void Function(String)? onFieldSubmitted;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      textInputAction: TextInputAction.next,
      scribbleEnabled: true,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
                icon: Icon(
                  widget.obscureText
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                ),
              )
            : null,
        labelText: widget.hintText,
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
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
