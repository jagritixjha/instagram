import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/widgets/small_text.dart';

class AppExtension {
  static customImagePicker({
    required ImageSource imageSource,
    required BuildContext context,
  }) async {
    ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(source: imageSource);

    if (pickedImage != null) {
      return await pickedImage.readAsBytes();
    } else {
      log("No image picked");
    }
  }

  static showCustomSnackbar({
    required String msg,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SmallText(
          textAlign: TextAlign.start,
          text: msg,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
