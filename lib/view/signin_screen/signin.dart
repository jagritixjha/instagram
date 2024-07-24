import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/view/navigation_screen/navigation_screen.dart';
import 'package:instagram/view/signup_screen/signup.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/secondary_button.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:instagram/widgets/textformfield.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void signInMethod() async {
    try {
      setState(() {
        isLoading = true;
      });
      String response = await AuthMethods().signInUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      if (response != 'success') {
        AppExtension.showCustomSnackbar(msg: response, context: context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationScreen(),
          ),
        );
      }
    } catch (error) {
      AppExtension.showCustomSnackbar(msg: error.toString(), context: context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Instagram',
                style: GoogleFonts.dancingScript(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Image.asset(
                'assets/logos/insta.png',
                height: 66,
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                hintText: 'Email',
                controller: emailController,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextFormField(
                isObsecured: true,
                hintText: 'Password',
                controller: passwordController,
              ),
              const SizedBox(
                height: 22,
              ),
              PrimaryButton(
                text: 'Log in',
                onPressed: signInMethod,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeCap: StrokeCap.round,
                      )
                    : null,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextButton(
                fontWeight: FontWeight.w500,
                textColor: Colors.grey.shade600,
                text: 'Forgotten Password?',
                onTap: () {},
              ),
              const Spacer(),
              SecondaryButton(
                text: 'Create new account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
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
