import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/view/profile_screen/profile_screen.dart';
import 'package:instagram/widgets/small_text.dart';

class UserAccountsListView extends StatelessWidget {
  const UserAccountsListView({
    super.key,
    required this.userSnapshot,
  });

  final QuerySnapshot<Map<String, dynamic>>? userSnapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userSnapshot!.docs.length,
      itemBuilder: (context, index) {
        UserModel userDetails = UserModel.fromSnap(userSnapshot!.docs[index]);

        return ListTile(
          visualDensity: VisualDensity.compact,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userDetails.photoUrl),
            radius: 30,
          ),
          title: SmallText(
            textAlign: TextAlign.left,
            text: userDetails.userName,
          ),
          subtitle: SmallText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            textAlign: TextAlign.left,
            text: userDetails.bio,
          ),
          onTap: () {
            log(userDetails.uid.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: userDetails.uid),
              ),
            );
          },
        );
      },
    );
  }
}
