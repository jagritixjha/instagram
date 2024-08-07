import 'package:flutter/material.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/small_text.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.fontWeight,
  });
  final String text;
  void Function()? onTap;
  Color? textColor;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SmallText(
        textAlign: TextAlign.start,
        text: text,
        maxLine: 1,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: 14,
        color: textColor ?? primaryColor,
      ),
    );
  }
}
