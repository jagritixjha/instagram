import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/widgets/profile_card.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  var snapshot;
  ProfileScreen({super.key, this.snapshot});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  String? username;

  @override
  Widget build(BuildContext context) {
    UserModel? userProvider =
        Provider.of<UserProvider>(context, listen: false).getUser;

    return Scaffold(
      appBar: AppBar(
        title: SmallText(
          text: widget.snapshot != null
              ? widget.snapshot['userName']
              : userProvider!.userName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', isEqualTo: _userId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CustomProgressIndicator(
                    color: true,
                  );
                }
                return ProfileCardWidget(
                  snapshot: userProvider!,
                  isCurrentUser: true,
                );
              }),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: _userId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CustomProgressIndicator(
                    color: true,
                  );
                }
                return PostGridView(
                  snapshot: snapshot,
                );
              })
        ],
      ),
    );
  }
}
