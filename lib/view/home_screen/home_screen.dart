import 'package:flutter/material.dart';
import 'package:instagram/widgets/small_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SmallText(
          text: 'Home Screen',
          fontSize: 20,
        ),
      ),
    );
  }
}
