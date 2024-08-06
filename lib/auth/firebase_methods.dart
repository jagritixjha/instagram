import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/auth/storage_methods.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  String likePost(
    String postId,
    String uid,
    List like,
  ) {
    String response = 'Some error occurred';
    try {
      if (like.contains(uid)) {
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
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
            .collection('post')
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
      await _firestore.collection('post').doc(postId).delete();
      response = 'success';
    } catch (error) {
      response = error.toString();
    }
    return response;
  }
}
