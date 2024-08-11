import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/auth/firebase_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:instagram/widgets/text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadPostScreen extends StatefulWidget {
  UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  TextEditingController captionController = TextEditingController();

  Uint8List? _pickedImage;
  bool isloading = false;

  Future pickImage() async {
    _pickedImage = await AppExtension.customImagePicker(
        imageSource: ImageSource.gallery, context: context);

    setState(() {});
  }

  Future sharePost({
    required String uid,
    required String userName,
    required String profileImage,
  }) async {
    try {
      setState(() {
        isloading = true;
      });
      String postId = const Uuid().v1();
      String response = await FirebaseMethod().uploadPost(
        captionController.text,
        _pickedImage!,
        uid,
        userName,
        profileImage,
        postId,
      );
      if (response == 'success') {
        AppExtension.showCustomSnackbar(
          msg: 'Uploaded post',
          context: context,
        );
        setState(() {
          isloading = false;
          _pickedImage = null;
        });
      } else {
        AppExtension.showCustomSnackbar(
          msg: response,
          context: context,
        );
      }
    } catch (error) {
      AppExtension.showCustomSnackbar(
        msg: error.toString(),
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.close,
          ),
        ),
        title: const SmallText(
          text: 'New Post',
          fontSize: 20,
        ),
      ),
      body: _pickedImage == null
          ? Padding(
              padding: padding,
              child: Center(
                child: PrimaryButton(
                  text: 'Select Image to Post',
                  onPressed: pickImage,
                ),
              ),
            )
          : ListView(
              children: [
                SizedBox(
                  height: 450,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(_pickedImage!),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextButton(
                          text: 'Change Image',
                          onTap: pickImage,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        CustomTextFormField(
                          hintText: 'Write a caption',
                          controller: captionController,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        PrimaryButton(
                          text: 'Share',
                          onPressed: () {
                            sharePost(
                              profileImage: userProvider.getUser!.photoUrl,
                              uid: userProvider.getUser!.uid,
                              userName: userProvider.getUser!.userName,
                            );
                          },
                          child: isloading
                              ? const CustomProgressIndicator()
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
