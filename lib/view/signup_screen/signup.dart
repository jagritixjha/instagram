import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/view/signin_screen/signin.dart';
import 'package:instagram/view/signup_screen/widegt/build_form.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Uint8List? _pickedProfileImage;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  void selectProfileImage() async {
    Uint8List pickedImage = await AppExtension.customImagePicker(
      imageSource: ImageSource.gallery,
      context: context,
    );

    if (pickedImage.isNotEmpty) {
      setState(() {
        _pickedProfileImage = pickedImage;
      });
    } else {
      log('error');
    }
  }

  void signUpMethod() async {
    try {
      setState(() {
        isLoading = true;
      });
      String response = await AuthMethods().signUpUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userName: usernameController.text.trim(),
        bio: 'hello there!!',
        file: _pickedProfileImage!,
      );
      setState(() {
        isLoading = false;
      });
      if (response != 'success') {
        AppExtension.showCustomSnackbar(msg: response, context: context);
      } else {
        navigateToSignIn();
      }
    } catch (error) {
      AppExtension.showCustomSnackbar(msg: error.toString(), context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.black54,
      body: SafeArea(
        child: Padding(
          padding: padding,
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
              BuildForm(
                emailController: emailController,
                usernameController: usernameController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
              ),
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
                onPressed: signUpMethod,
                child: isLoading ? CustomProgressIndicator() : null,
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
