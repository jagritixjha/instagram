import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/small_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmallText(
          text: 'jagritixjha',
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/77/9c/ae/779caee3e30b3e6c88acd36dc62a5426.jpg'),
                ),
                const Spacer(),
                CustomRichText(
                  str: '0',
                  subStr: 'posts',
                ),
                const Spacer(),
                CustomRichText(
                  str: '104',
                  subStr: 'followers',
                ),
                const Spacer(),
                CustomRichText(
                  str: '119',
                  subStr: 'following',
                ),
              ],
            ),
          ),
          BuildSection2(),
          SizedBox(
            height: 14,
          ),
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

class BuildSection2 extends StatelessWidget {
  const BuildSection2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          const SmallText(
            text: 'Jagriti Jha',
            textAlign: TextAlign.start,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SmallText(
            text: 'Chasing life\'s destiny',
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
                text: 'Follow',
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
