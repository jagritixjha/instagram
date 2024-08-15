import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/auth/storage_methods.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _auth = FirebaseAuth.instance.currentUser!;

  Future<String> uploadPost(
    String description,
    Uint8List post,
    String uid,
    String userName,
    String profileImage,
    String postId,
  ) async {
    String response = 'Some error occurred';

    try {
      String photoUrl = await StorageMethod().updateImageToStorage(
        childName: 'post',
        imageFile: post,
        isPost: true,
        postId: postId,
      );

      UserPost postDetails = UserPost(
        description: description,
        uid: uid,
        username: userName,
        postId: postId,
        datePublish: DateTime.now(),
        photoUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(postDetails.toJson());
      response = 'success';
      return response;
    } catch (error) {
      response = error.toString();
      return response;
    }
  }

  Future<String> likePost(String postId, String uid, List likes,
      {required bool isLiked}) async {
    String response = 'Some error occurred';
    try {
      if (!isLiked) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
        log('removed');
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        log('added');
      }
      response = 'success';
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<String> savePost(String postId, bool isSaved) async {
    String response = 'some error occurred';
    try {
      if (isSaved) {
        await _firestore.collection('user').doc(_auth.uid).update({
          'savedPosts': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore.collection('user').doc(_auth.uid).update({
          'savedPosts': FieldValue.arrayUnion([postId]),
        });
      }
      response = 'success';
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<String> followAccount(bool follow, String postUserUid) async {
    String response = 'some error occurred';
    try {
      if (follow) {
        await _firestore.collection('user').doc(_auth.uid).update({
          'following': FieldValue.arrayRemove([postUserUid]),
        });
        await _firestore.collection('user').doc(postUserUid).update({
          'followers': FieldValue.arrayRemove([_auth.uid]),
        });
      } else {
        await _firestore.collection('user').doc(_auth.uid).update({
          'following': FieldValue.arrayUnion([postUserUid]),
        });
        await _firestore.collection('user').doc(postUserUid).update({
          'followers': FieldValue.arrayUnion([_auth.uid]),
        });
      }
      response = 'success';
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String response = 'Some error occurred';
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'dateOfPublish': DateTime.now(),
        });
        response = 'success';
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<String> deletePost(String postId) async {
    String response = 'Some error occurred';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      response = 'success';
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  // Future<String> savePost(String postUid,String userId,) async{
  //   String response='some error occurred';
  //   try{
  //     await _firestore.collection('users').doc(userId).update(data)
  //   }catch(e){
  //     response = e.toString();
  //   }
  //   return response;
  // }
}
