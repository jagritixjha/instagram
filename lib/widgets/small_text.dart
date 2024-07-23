import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  const SmallText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color = Colors.black,
    this.maxLine = 1,
    this.textAlign = TextAlign.center,
  });
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        maxLines: maxLine,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: color,
          ),
        ));
  }
}
