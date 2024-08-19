import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/auth/firebase_methods.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/view/profile_screen/followers_following_screen.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/small_text.dart';

class ProfileCardWidget extends StatefulWidget {
  ProfileCardWidget({
    super.key,
    required this.user,
    required this.postCount,
  });
  UserModel? user;
  String postCount = '';

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  late bool isFollowing;
  void followAccount() async {
    String response =
        await FirebaseMethod().followAccount(isFollowing, widget.user!.uid);
    if (response == 'success') {
      AppExtension.showCustomSnackbar(
          msg: isFollowing ? 'account followed' : 'account unfollowed',
          context: context);
      setState(() {
        isFollowing = !isFollowing;
      });
      log(isFollowing.toString());
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollowing = widget.user!.followers.contains(_currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.user!.uid != _currentUserId
                  ? IconButton(
                      visualDensity: VisualDensity.compact,
                      padding:
                          const EdgeInsets.only(right: 30, bottom: 16, top: 16),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : Container(),
              SmallText(
                text: widget.user!.userName,
              ),
              const Spacer(),
              widget.user!.uid == _currentUserId
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
                backgroundImage: NetworkImage(widget.user!.photoUrl),
              ),
              const Spacer(),
              CustomRichText(
                str: widget.postCount,
                subStr: 'posts',
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowersFollowingScreen(
                        followersList: widget.user!.followers,
                        followingList: widget.user!.following,
                        userId: widget.user!.uid,
                        userName: widget.user!.userName,
                        index: 0,
                      ),
                    ),
                  );
                },
                child: CustomRichText(
                  str: widget.user!.followers.length.toString(),
                  subStr: 'followers',
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowersFollowingScreen(
                        followersList: widget.user!.followers,
                        followingList: widget.user!.following,
                        userId: widget.user!.uid,
                        userName: widget.user!.userName,
                        index: 1,
                      ),
                    ),
                  );
                },
                child: CustomRichText(
                  str: widget.user!.following.length.toString(),
                  subStr: 'following',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SmallText(
            text: widget.user!.userName,
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          SmallText(
            text: widget.user!.bio,
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 8,
          ),
          SecondaryActionButton(
            text: widget.user!.uid == _currentUserId
                ? 'Edit profile'
                : isFollowing
                    ? 'Following'
                    : 'Follow',
            isProfile: true,
            bgColor: isFollowing ? Colors.blueAccent.shade200 : primaryColor,
            onPressed: () {
              widget.user!.uid != _currentUserId ? followAccount() : null;
            },
          )
        ],
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.str,
    required this.subStr,
  });
  final String str;
  final String subStr;

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
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
