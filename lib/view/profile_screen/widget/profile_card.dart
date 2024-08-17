import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/controller/post_provider.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:provider/provider.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({
    super.key,
    required this.user,
  });
  UserModel? user;
  String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              user!.uid != _currentUserId
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : Container(),
              // const SizedBox(
              //   width: 16,
              // ),
              SmallText(
                text: user!.userName,
              ),
              const Spacer(),
              user!.uid == _currentUserId
                  ? IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout_rounded),
                    )
                  : Container(),
            ],
          ),
          Divider(
            height: 0,
            thickness: 0,
            color: Colors.indigo.shade50,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              const Spacer(),
              CustomRichText(
                str: postLength.toString(),
                subStr: 'posts',
              ),
              const Spacer(),
              CustomRichText(
                str: user!.followers.length.toString(),
                subStr: 'followers',
              ),
              const Spacer(),
              CustomRichText(
                str: user!.following.length.toString(),
                subStr: 'following',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SmallText(
            text: user!.userName,
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          SmallText(
            text: user!.bio,
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
                text: user!.uid == _currentUserId ? 'Edit profile' : 'Follow',
                isProfile: true,
                bgColor: primaryColor,
              ),
              SecondaryActionButton(
                text: 'Message',
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
