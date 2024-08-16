import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/view/home_screen/home_screen.dart';

int? postLength;

class PostGridView extends StatelessWidget {
  PostGridView({
    super.key,
    required this.snapshot,
    this.isProfile = false,
  });
  final bool isProfile;

  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var postDetails = snapshot.data!.docs[index];
          postLength = snapshot.data!.docs.length;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    post: postDetails,
                    isProfile: isProfile,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: 210,
              width: 200,
              child: Image.network(
                postDetails['photoUrl'],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
