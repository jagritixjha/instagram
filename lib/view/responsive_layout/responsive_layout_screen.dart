import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/utils/constants.dart';
import 'package:provider/provider.dart';

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

  addData() async {
    UserProvider refreshUser = Provider.of(context, listen: false);
    await refreshUser.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    log('---- responsive screen called');

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
