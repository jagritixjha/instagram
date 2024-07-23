import 'package:flutter/material.dart';
import 'package:instagram/widgets/small_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SmallText(
          text: 'Profile Screen',
          fontSize: 20,
        ),
      ),
    );
  }
}
