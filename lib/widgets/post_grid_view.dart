import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:instagram/view/home_screen/home_screen.dart';

class PostGridView extends StatelessWidget {
  PostGridView({super.key, this.isProfile = false, required this.postSnapshot});
  final bool isProfile;
  QuerySnapshot<Map<String, dynamic>> postSnapshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: postSnapshot.docs.length,
        itemBuilder: (context, index) {
          var postDetails = postSnapshot.docs[index];
          final post = UserPost.fromSnap(postSnapshot.docs[index]);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    post: postDetails,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: 210,
              width: 200,
              child: Image.network(
                post.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
