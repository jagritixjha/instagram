import 'package:flutter/material.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/small_text.dart';

class SecondaryActionButton extends StatelessWidget {
  SecondaryActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isProfile = false,
    this.bgColor,
  });

  String text;
  bool isProfile;
  Color? bgColor;

  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: bgColor ?? Colors.indigo.shade50,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        minimumSize:
            isProfile ? Size(MediaQuery.of(context).size.width - 24, 44) : null,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: SmallText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: bgColor != null ? Colors.white : Colors.black87,
      ),
    );
  }
}
