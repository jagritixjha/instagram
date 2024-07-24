import 'package:flutter/material.dart';
import 'package:instagram/widgets/textformfield.dart';

class BuildForm extends StatelessWidget {
  BuildForm({
    super.key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  TextEditingController emailController;
  TextEditingController usernameController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        CustomTextFormField(
          hintText: 'Enter email',
          controller: emailController,
        ),
        const SizedBox(
          height: 12,
        ),
        CustomTextFormField(
          hintText: 'Enter username',
          controller: usernameController,
        ),
        const SizedBox(
          height: 12,
        ),
        CustomTextFormField(
          isObsecured: true,
          hintText: 'Enter password',
          controller: passwordController,
        ),
        const SizedBox(
          height: 12,
        ),
        CustomTextFormField(
          isObsecured: true,
          hintText: 'Confirm password',
          controller: confirmPasswordController,
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }
}
