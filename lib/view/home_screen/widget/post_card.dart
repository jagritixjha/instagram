import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/auth/firebase_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/post_model.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/utils/image_picker.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/primary_button.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:instagram/widgets/text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  PostCard({
    super.key,
    required this.snapshot,
    required this.index,
  });

  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  int index;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  TextEditingController commentController = TextEditingController();
  bool isLiked = false;
  bool isSaved = false;
  bool following = false;

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
      return DateFormat('d MMMM').format(
        postDetails['datePublish'].toDate(),
      );
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

  void savePost() async {
    String response =
        await FirebaseMethod().savePost(postDetails['postId'], isSaved);

    if (response == 'success') {
      AppExtension.showCustomSnackbar(
          msg: isSaved ? 'post saved' : 'post unsaved', context: context);
      setState(() {
        isSaved = !isSaved;
      });
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  void followAccount() async {
    String response =
        await FirebaseMethod().followAccount(following, postDetails['uid']);

    if (response == 'success') {
      AppExtension.showCustomSnackbar(
          msg: following ? 'account followed' : 'account unfollowed',
          context: context);
      setState(() {
        following = !following;
      });
    } else {
      AppExtension.showCustomSnackbar(msg: response, context: context);
    }
  }

  UserModel? user;
  UserPost? post;
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    following = user!.following.contains(postDetails['uid']);
    isSaved = user!.savedPosts.contains(postDetails['postId']);
    isLiked = postDetails['likes'].contains(user!.uid);
    commentSnapshot;
    post =
        UserPost.fromSnap(widget.snapshot.data!.docs.elementAt(widget.index));
  }

  Future<void> likePost() async {
    setState(() {
      isLiked = !isLiked;
    });
    log(isLiked.toString());
    String response = await FirebaseMethod().likePost(
      postDetails['postId'],
      user!.uid,
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

  String commentsCount = 'Loading...';
  get commentSnapshot async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postDetails['postId'])
        .collection('comments')
        .get();

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        commentsCount = snapshot.docs.length.toString();
      });
    }
    return snapshot;
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
            backgroundImage: NetworkImage(post!.profileImage),
          ),
          title: SmallText(
            textAlign: TextAlign.start,
            text: post!.username,
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
              SecondaryActionButton(
                text: following ? 'Following' : 'Follow',
                onPressed: followAccount,
              ),
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
            image: DecorationImage(
              image: NetworkImage(
                post!.photoUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          children: [
            PostActionButtons(
              text: post!.likes.length.toString(),
              icon: isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              iconColor: isLiked ? Colors.red : Colors.black,
              onPressed: likePost,
            ),
            const SizedBox(
              width: 4,
            ),
            PostActionButtons(
              text: commentsCount,
              icon: CupertinoIcons.chat_bubble,
              // icon: CupertinoIcons.chat_bubble,
              onPressed: buildCommentSection,
            ),
            const SizedBox(
              width: 4,
            ),
            PostActionButtons(
              text: '69.6K',
              icon: CupertinoIcons.arrow_turn_right_up,
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: savePost,
              visualDensity: VisualDensity.comfortable,
              icon: Icon(
                isSaved
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
                size: 24,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SmallText(
                text: '${post!.username}  ${post!.description}️',
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

  void buildCommentSection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, top: 40, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                  hintText: 'write comment', controller: commentController),
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
  }
}

class PostActionButtons extends StatelessWidget {
  const PostActionButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconColor,
  });

  final String text;
  final IconData icon;
  final void Function()? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        overlayColor: Colors.transparent,
      ),
      icon: Icon(
        icon,
        size: 24,
        color: iconColor ?? Colors.black,
      ),
      label: SmallText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
