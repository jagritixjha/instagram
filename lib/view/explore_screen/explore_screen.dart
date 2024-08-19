import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/modal/user_model.dart';
import 'package:instagram/widgets/account_list_view.dart';
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
                  future: FirebaseFirestore.instance
                      .collection('user')
                      .where(
                        'userName',
                        isGreaterThanOrEqualTo: searchController.text,
                      )
                      .get(),
                  builder: (context, snapshot) {
                    return Expanded(
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? CustomProgressIndicator(
                              color: true,
                            )
                          : (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty ||
                                  snapshot.data == null)
                              ? const Center(
                                  child: SmallText(
                                    text: 'No users found.',
                                  ),
                                )
                              : UserAccountsListView(
                                  userSnapshot: snapshot.data!,
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
                      return Expanded(
                        child: CustomProgressIndicator(
                          color: true,
                        ),
                      );
                    }
                    return PostGridView(postSnapshot: snapshot.data!);
                  }),
        ],
      ),
    );
  }
}
