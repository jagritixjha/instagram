import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/view/profile_screen/widget/profile_card.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:provider/provider.dart';

import '../../modal/post_model.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  ProfileScreen({super.key, String? userId})
      : userId = userId ?? FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> _getUserAndPostData() async {
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    final postData = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .get();
    return {
      'userData': userData,
      'postData': postData,
    };
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userProvider =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      body: FutureBuilder(
          future: _getUserAndPostData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomProgressIndicator(
                color: true,
              );
            }
            final userModel = UserModel.fromSnap(snapshot.data!['userData']);
            final postSnap = snapshot.data!['postData'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCardWidget(
                  user: userModel,
                ),
                const SizedBox(
                  height: 10,
                ),
                PostGridView(
                  isProfile: true,
                  postSnapshot: postSnap,
                ),
              ],
            );
          }),
    );
  }
}
