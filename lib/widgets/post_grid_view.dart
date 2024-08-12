import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int? postLength;

class PostGridView extends StatelessWidget {
  PostGridView({
    super.key,
    required this.snapshot,
  });

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
        itemCount: (snapshot.data! as dynamic).docs.length,
        itemBuilder: (context, index) {
          var postDetails = snapshot.data!.docs[index];
          postLength = (snapshot.data! as dynamic).docs.length;

          return SizedBox(
            height: 210,
            width: 200,
            child: Image.network(
              postDetails['photoUrl'],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
