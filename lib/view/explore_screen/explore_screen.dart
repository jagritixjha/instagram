import 'package:flutter/material.dart';
import 'package:instagram/widgets/small_text.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SmallText(
          text: 'Explore Screen',
          fontSize: 20,
        ),
      ),
    );
  }
}
