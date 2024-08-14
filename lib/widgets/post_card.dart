import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/auth/firebase_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:instagram/widgets/text_form_field.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  PostCard({
    super.key,
    required this.snapshot,
    required this.index,
    required this.userUid,
  });

  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  int index;
  String userUid;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  TextEditingController commentController = TextEditingController();
  bool isLiked = false;

  dynamic get postDetails {
    return widget.snapshot.data!.docs[widget.index];
  }

  String postDateTime() {
    final now = DateTime.now();
    final difference = now.difference(postDetails['datePublish'].toDate());

    if (difference.inMinutes == 0) {
      return 'just now';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours <= 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('d MMMM').format(postDetails['datePublish']);
    }
  }

  void deletePost() async {
    String response = await FirebaseMethod().deletePost(postDetails['postId']);
    if (response == 'success') {
      AppExtension.showCustomSnackbar(msg: 'post deleted', context: context);
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  void postComment() async {
    String response = await FirebaseMethod().postComment(
      postDetails['postId'],
      commentController.text,
      postDetails['uid'],
      postDetails['username'],
      postDetails['profileImage'],
    );
    if (response == 'success') {
      AppExtension.showCustomSnackbar(msg: 'comment posted', context: context);
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  @override
  void initState() {
    super.initState();
    isLiked = postDetails['likes'].contains(widget.userUid);
  }

  Future<void> likePost() async {
    setState(() {
      isLiked = !isLiked;
    });
    log(isLiked.toString());
    String response = await FirebaseMethod().likePost(
      postDetails['postId'],
      widget.userUid,
      postDetails['likes'],
      isLiked: isLiked,
    );

    if (response == 'success') {
      AppExtension.showCustomSnackbar(
        msg: isLiked ? 'Post liked' : 'Post unliked',
        context: context,
      );
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.bottom,
          contentPadding: const EdgeInsets.only(left: 12),
          visualDensity: VisualDensity.compact,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(postDetails['profileImage']),
          ),
          title: SmallText(
            textAlign: TextAlign.start,
            text: postDetails['username'],
            fontSize: 12,
          ),
          subtitle: SmallText(
            textAlign: TextAlign.start,
            text: postDateTime(),
            fontSize: 12,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SecondaryActionButton(text: 'Follow'),
              PopupMenuButton<String>(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                padding: EdgeInsets.zero,
                onSelected: (String value) {
                  switch (value) {
                    case 'delete post':
                      setState(() {
                        deletePost();
                      });
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete post',
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.delete),
                      title: SmallText(text: 'Delete Post'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 450,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Colors.red,
            image: DecorationImage(
              image: NetworkImage(
                postDetails['photoUrl'],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: likePost,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                size: 28,
                color: isLiked ? Colors.red : Colors.black,
              ),
            ),
            const SmallText(
              text: '187K',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              width: 4,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 40, bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                              hintText: 'write comment',
                              controller: commentController),
                          const Spacer(),
                          PrimaryButton(
                            text: 'Post comment',
                            onPressed: () {
                              postComment();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                CupertinoIcons.chat_bubble,
                size: 28,
                color: Colors.black,
              ),
            ),
            const SmallText(
              text: '1,485',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              width: 4,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.navigation_outlined,
                size: 28,
                color: Colors.black,
              ),
            ),
            const SmallText(
              text: '69.6K',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              visualDensity: VisualDensity.comfortable,
              icon: const Icon(
                CupertinoIcons.bookmark,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SmallText(
                text:
                    '${postDetails['username']}  ${postDetails['description']}️',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomTextButton(
            text: 'View all 1,578 comments',
            fontWeight: FontWeight.w500,
            textColor: Colors.grey.shade600,
            onTap: () {},
          ),
        )
      ],
    );
  }
}
