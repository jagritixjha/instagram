import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/modal/post_model.dart';

class UserPostProvider extends ChangeNotifier {
  // UserPost? _userPost;
  // UserPost? get getUser => _userPost!;
  //
  // Future<void> postDetails({required String postId}) async {
  //   UserPost post = await AuthMethods().getPostDetails(postId: postId);
  //   _userPost = post;
  //   notifyListeners();
  // }

  int _postLength = 0;
  int get postLength => _postLength;

  UserPostProvider() {
    fetchPostLength();
  }

  Future<void> fetchPostLength() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    _postLength = querySnapshot.docs.length;
    notifyListeners();
  }
}
