import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/auth/storage_methods.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:instagram/modal/user_model.dart' as model;
import 'package:instagram/modal/user_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  get currentUser => _auth.currentUser!.uid;

  Future<model.UserModel> getUserDetails(String? userUid) async {
    User currentUserDetails = _auth.currentUser!;

    DocumentSnapshot snap = await _firebaseFirestore
        .collection('user')
        .doc(userUid ?? currentUserDetails.uid)
        .get();
    return model.UserModel.fromSnap(snap);
  }

  Future<UserPost> getPostDetails({required String postId}) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('posts').doc(postId).get();
    return UserPost.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String response = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethod().updateImageToStorage(
          childName: 'pfp',
          imageFile: file,
        );

        UserModel userModel = UserModel(
          userName: userName,
          email: email,
          password: password,
          bio: bio,
          followers: [],
          following: [],
          savedPosts: [],
          photoUrl: photoUrl,
          uid: credential.user!.uid,
        );
        await _firebaseFirestore
            .collection('user')
            .doc(credential.user!.uid)
            .set(
              userModel.toJson(),
            );

        response = 'success';
      } else {
        response = 'Please enter all the details';
      }
    } catch (error) {
      log("Error during user creation: $error");

      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          response = 'Email is already in use.';
        } else if (error.code == 'weak-password') {
          response = 'Weak password. Please use a stronger password.';
        } else if (error.code == 'invalid-email') {
          response = 'Invalid email address';
        } else {
          response = 'User creation failed. Please try again later.';
        }
      } else {
        response = "Unexpected error during user creation.";
      }
      return response;
    }
    return response;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String response = 'some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = 'success';
      } else {
        response = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        response = 'Invalid email used.';
      } else if (error.code == 'user-disabled') {
        response = 'This user is disabled currently.';
      } else if (error.code == 'user-not-found') {
        response = 'No account found.';
      } else if (error.code == 'wrong-password') {
        response = 'Incorrect password.';
      } else {
        response = 'Sign in failed. Please try again later.';
      }
      return response;
    }
    return response;
  }
}
