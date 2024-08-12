import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/action_button.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.snapshot, required this.index});

  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  int index;

  @override
  Widget build(BuildContext context) {
    var postDetails = (snapshot.data!.docs as dynamic)[index];

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
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  size: 20,
                ),
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
              onPressed: () {},
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                CupertinoIcons.heart,
                size: 28,
                color: Colors.black,
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
              onPressed: () {},
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
          padding: EdgeInsets.symmetric(horizontal: 12),
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
