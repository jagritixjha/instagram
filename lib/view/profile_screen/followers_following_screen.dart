import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/account_list_view.dart';
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
  @override
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
                text: 'Followers',
                onTap: () {
                  setState(() {
                    widget.index = 0;
                  });
                },
              ),
              TabButtons(
                text: 'Following',
                onTap: () {
                  setState(() {
                    widget.index = 1;
                  });
                },
              ),
            ],
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('user')
                .where(FieldPath.documentId, whereIn: widget.followingList)
                .get(),
            builder: (context, snapshot) => Expanded(
              child: IndexedStack(
                index: widget.index,
                children: [
                  UserAccountsListView(
                    userSnapshot: snapshot.data!,
                    itemCount: snapshot.data!.docs.length,
                  ),
                  UserAccountsListView(
                    userSnapshot: snapshot.data!,
                    itemCount: snapshot.data!.docs.length,
                  ),
                ],
              ),
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
  });
  void Function()? onTap;
  String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black87, width: 2),
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
