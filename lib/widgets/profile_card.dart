import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/controller/post_provider.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:provider/provider.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({
    super.key,
    required this.snapshot,
    this.isCurrentUser = false,
    // this.postLength,
  });

  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserPostProvider userPostProvider =
        Provider.of<UserPostProvider>(context, listen: false);

    // final post = FirebaseFirestore.instance
    //     .collection('posts')
    //     .where('uid', isEqualTo: userProvider.getUser!.uid)
    //     .get();
    // final postLength = post.docs.length;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProvider.getUser!.photoUrl),
              ),
              const Spacer(),
              CustomRichText(
                str: userPostProvider.postLength.toString(),
                subStr: 'posts',
              ),
              const Spacer(),
              CustomRichText(
                str: userProvider.getUser!.followers.length.toString(),
                subStr: 'followers',
              ),
              const Spacer(),
              CustomRichText(
                str: userProvider.getUser!.followers.length.toString(),
                subStr: 'following',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SmallText(
            text: userProvider.getUser!.userName,
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          SmallText(
            text: userProvider.getUser!.bio,
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryActionButton(
                text: isCurrentUser ? 'Edit profile' : 'Follow',
                isProfile: true,
                bgColor: primaryColor,
              ),
              SecondaryActionButton(
                text: 'Message',
                isProfile: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  CustomRichText({
    super.key,
    required this.str,
    required this.subStr,
  });
  String str;
  String subStr;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: str,
        style: GoogleFonts.poppins(
          height: 1.2,
          textStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        children: [
          TextSpan(
            text: '\n$subStr',
            style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
