import 'package:flutter/material.dart';
import 'package:instagram/utils/constants.dart';

class CustomProgressIndicator extends StatelessWidget {
  CustomProgressIndicator({
    super.key,
    this.color = false,
  });
  bool color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: color ? primaryColor : Colors.white,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
