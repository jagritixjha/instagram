import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/auth/storage_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_form_field.dart';
import 'package:provider/provider.dart';

class EditDetailsScreen extends StatefulWidget {
  EditDetailsScreen({super.key});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  Uint8List? _pickedProfileImage;

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

  UserModel? get user =>
      Provider.of<UserProvider>(context, listen: false).getUser;

  TextEditingController? emailController;
  TextEditingController? usernameController;
  TextEditingController? nameController;
  TextEditingController? bioController;

  @override
  void initState() {
    super.initState();
    UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;

    emailController = TextEditingController(text: user?.email ?? '');
    usernameController = TextEditingController(text: user?.userName ?? '');
    nameController = TextEditingController(text: user?.name ?? '');
    bioController = TextEditingController(text: user?.bio ?? '');
  }

  updateDetails() async {
    UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;
    String? photoUrl = user?.photoUrl;

    try {
      if (_pickedProfileImage != null) {
        photoUrl = await StorageMethod().updateImageToStorage(
          childName: 'pfp',
          imageFile: _pickedProfileImage!,
        );
      }
      if (user != null) {
        QuerySnapshot emailQuery = await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: emailController!.text)
            .get();

        QuerySnapshot usernameQuery = await FirebaseFirestore.instance
            .collection('user')
            .where('userName', isEqualTo: usernameController!.text)
            .get();

        bool emailExists = emailQuery.docs.isNotEmpty &&
            emailQuery.docs.first.id != user.uid; // Exclude current user
        bool usernameExists = usernameQuery.docs.isNotEmpty &&
            usernameQuery.docs.first.id != user.uid; // Exclude current user

        if (emailExists) {
          AppExtension.showCustomSnackbar(
              msg: 'Email is already in use by another account',
              context: context);
          return;
        }

        if (usernameExists) {
          AppExtension.showCustomSnackbar(
              msg: 'Username is already taken', context: context);
          return;
        }
        FirebaseFirestore.instance.collection('user').doc(user.uid).update({
          'email': emailController!.text,
          'bio': bioController!.text,
          'name': nameController!.text,
          'userName': usernameController!.text,
          'photoUrl': photoUrl,
        });
        AppExtension.showCustomSnackbar(
            msg: 'Details updated', context: context);
        Navigator.canPop(context);
      } else {
        print('User is not available.');
      }
    } catch (e) {
      AppExtension.showCustomSnackbar(msg: e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const SmallText(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          text: 'Edit details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            Flexible(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _pickedProfileImage == null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(user!.photoUrl),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_pickedProfileImage!),
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
            ),
            const SizedBox(
              height: 44,
            ),
            CustomTextFormField(
              hintText: 'Enter email',
              controller: emailController!,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              hintText: 'Enter username',
              controller: usernameController!,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              hintText: 'Enter name',
              controller: nameController!,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              hintText: 'Enter bio',
              controller: bioController!,
            ),
            const SizedBox(
              height: 44,
            ),
            PrimaryButton(text: 'Done', onPressed: updateDetails)
          ],
        ),
      ),
    );
  }
}
