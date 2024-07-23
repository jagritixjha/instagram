import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/view/signin_screen/signin.dart';
import 'package:instagram/view/signup_screen/widegt/build_form.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  Uint8List? _pickedProfileImage;

  void selectProfileImage() {}

  @override
  Widget build(BuildContext context) {
    log('build called');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.black54,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Instagram',
                      style: GoogleFonts.dancingScript(
                        textStyle: const TextStyle(
                          fontSize: 36,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextSpan(
                      text:
                          '\nSign up to see photos and videos from your friends.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  _pickedProfileImage != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_pickedProfileImage!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor:
                              Colors.blueGrey.shade200.withOpacity(0.4),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade50,
                      ),
                      child: IconButton(
                        onPressed: selectProfileImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              BuildForm(),
              Text.rich(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey.shade900,
                  ),
                ),
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'By signing up, you agree to our',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' Terms,\n',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy ',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                    const TextSpan(
                      text: 'and',
                    ),
                    TextSpan(
                      text: '  Cookies Policy.',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              PrimaryButton(
                text: 'Sign up',
                onPressed: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              SmallText(
                text: 'Already have an account?',
                maxLine: 1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.grey.shade900,
              ),
              CustomTextButton(
                text: 'Log in',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
