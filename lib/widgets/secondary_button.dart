import 'package:flutter/material.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/small_text.dart';

class SecondaryButton extends StatelessWidget {
  SecondaryButton({super.key, required this.text, required this.onPressed});
  String text;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor, width: 1),
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: onPressed,
      child: SmallText(
        text: text,
        maxLine: 2,
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
