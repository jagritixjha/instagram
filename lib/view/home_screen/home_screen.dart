import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.post, this.isProfile = false});
  final DocumentSnapshot? post;
  final bool isProfile;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 32,
        forceMaterialTransparency: true,
        title: post == null
            ? Text(
                'instagram',
                style: GoogleFonts.dancingScript(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            : SmallText(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                text: isProfile ? 'Posts' : 'Explore',
              ),
        actions: post == null
            ? [
                IconButton(
                  onPressed: () {
                    // Handle like action
                  },
                  icon: const Icon(
                    CupertinoIcons.heart,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.text_bubble,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
              ]
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SmallText(
              textAlign: TextAlign.start,
              text: 'Suggested for you',
              fontSize: 20,
            ),
          ),
          FutureBuilder(
            future: post == null
                ? FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublish', descending: true)
                    .get()
                : isProfile
                    ? FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: _userId)
                        .get()
                    : FirebaseFirestore.instance
                        .collection('posts')
                        .startAtDocument(post!)
                        .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: CustomProgressIndicator(
                    color: true,
                  ),
                );
              }
              return Expanded(
                child: ListView.separated(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snapshot: snapshot,
                    index: index,
                  ),
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 40,
                      color: Colors.indigo.shade50,
                      endIndent: 16,
                      indent: 16,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
