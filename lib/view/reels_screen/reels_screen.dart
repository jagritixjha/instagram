import 'package:flutter/material.dart';
import 'package:instagram/widgets/small_text.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SmallText(
          text: 'Reels Screen',
          fontSize: 20,
        ),
      ),
    );
  }
}
