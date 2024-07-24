import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String email;
  final String password;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  // setter
  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "password": password,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return UserModel(
      userName: snapShot['userName'],
      email: snapShot['email'],
      password: snapShot['password'],
      bio: snapShot['bio'],
      followers: snapShot['followers'],
      following: snapShot['following'],
      photoUrl: snapShot['photoUrl'],
    );
  }
}
