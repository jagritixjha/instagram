import 'package:flutter/material.dart';
import 'package:instagram/widgets/textformfield.dart';

class BuildForm extends StatelessWidget {
  BuildForm({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
