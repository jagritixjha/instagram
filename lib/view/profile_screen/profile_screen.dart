import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/view/profile_screen/widget/profile_card.dart';
import 'package:instagram/widgets/progress_indicator.dart';

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
      'postCount': postData.docs.length.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
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
                  postCount: snapshot.data!['postCount'],
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
