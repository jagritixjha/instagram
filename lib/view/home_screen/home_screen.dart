import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'instagram',
          style: GoogleFonts.dancingScript(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.black87,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
        ],
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
            future: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublish', descending: true)
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
