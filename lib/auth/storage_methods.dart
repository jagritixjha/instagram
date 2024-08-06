import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> updateImageToStorage({
    required String childName,
    required Uint8List imageFile,
    bool isPost = false,
    String? postId,
  }) async {
    Reference ref = isPost
        ? _storage
            .ref()
            .child(childName)
            .child(_auth.currentUser!.uid)
            .child(postId!)
        : _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask task = ref.putData(imageFile);

    TaskSnapshot snapshot = await task;
    String downloadImageUrl = await snapshot.ref.getDownloadURL();
    return downloadImageUrl;
  }
}
