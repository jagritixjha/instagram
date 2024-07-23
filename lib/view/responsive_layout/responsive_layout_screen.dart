import 'package:flutter/material.dart';
import 'package:instagram/utils/constants.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget webScreen, mobileScreen;
  ResponsiveLayout({
    super.key,
    required this.webScreen,
    required this.mobileScreen,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webConstraint) {
          return widget.webScreen;
        } else {
          return widget.mobileScreen;
        }
      },
    );
  }
}
