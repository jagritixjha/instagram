import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/account_list_view.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';

class FollowersFollowingScreen extends StatefulWidget {
  FollowersFollowingScreen({
    super.key,
    required this.followersList,
    required this.followingList,
    required this.userId,
    required this.userName,
    required this.index,
  });
  List followersList;
  List followingList;
  int index = 0;
  String userId;
  String userName;

  @override
  State<FollowersFollowingScreen> createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen> {
  Future<QuerySnapshot<Map<String, dynamic>>> _fetchUserDataFromList(
      List userIds) async {
    if (userIds.isEmpty) {
      return Future.value(null); // Return null if the list is empty
    }

    return FirebaseFirestore.instance
        .collection('user')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SmallText(
          text: widget.userName,
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TabButtons(
                isSelected: widget.index == 0,
                text: 'Followers',
                onTap: () {
                  setState(() {
                    widget.index = 0;
                  });
                },
              ),
              TabButtons(
                isSelected: widget.index == 1,
                text: 'Following',
                onTap: () {
                  setState(() {
                    widget.index = 1;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: widget.index == 0
                  ? _fetchUserDataFromList(widget.followersList)
                  : _fetchUserDataFromList(widget.followingList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomProgressIndicator(
                    color: true,
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty ||
                    snapshot.data == null) {
                  return Center(
                    child: SmallText(
                      text: 'No users found.',
                    ),
                  );
                }

                return UserAccountsListView(
                  userSnapshot: snapshot.data!,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class TabButtons extends StatelessWidget {
  TabButtons({
    super.key,
    required this.text,
    this.onTap,
    required this.isSelected,
  });
  void Function()? onTap;
  String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.black87 : Colors.transparent,
                width: 1.4,
              ),
            ),
          ),
          child: SmallText(
            text: text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
