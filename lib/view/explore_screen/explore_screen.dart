import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/view/home_screen/home_screen.dart';
import 'package:instagram/view/profile_screen/profile_screen.dart';
import 'package:instagram/widgets/post_grid_view.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_form_field.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchController = TextEditingController();

  bool showUser = false;
  Future fetchData() async {
    return await FirebaseFirestore.instance
        .collection('user')
        .where('userName', isGreaterThanOrEqualTo: searchController.text)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextFormField(
          hintText: 'Explore friends account',
          controller: searchController,
          onFieldSubmitted: (String _) {
            setState(() {
              showUser = true;
            });
          },
        ),
      ),
      body: Column(
        children: [
          Divider(
            height: 12,
            indent: 16,
            endIndent: 16,
            color: Colors.indigo.shade50,
          ),
          showUser
              ? FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: CustomProgressIndicator(
                          color: true,
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: (snapshot.data as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          var userDetails =
                              (snapshot.data as dynamic).docs[index];
                          return ListTile(
                            visualDensity: VisualDensity.compact,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                userDetails['photoUrl'],
                              ),
                              radius: 30,
                            ),
                            title: SmallText(
                              textAlign: TextAlign.left,
                              text: userDetails['userName'],
                            ),
                            subtitle: SmallText(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              textAlign: TextAlign.left,
                              text: userDetails['bio'],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(snapshot: userDetails),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  })
              : FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('datePublish')
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CustomProgressIndicator(
                        color: true,
                      );
                    }
                    return PostGridView(snapshot: snapshot);
                    /*Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot post = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    post: post,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 210,
                              width: 200,
                              child: Image.network(
                                post['photoUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    );*/
                  }),
        ],
      ),
    );
  }
}
