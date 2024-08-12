import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/progress_indicator.dart';
import 'package:instagram/widgets/small_text.dart';
import 'package:instagram/widgets/text_form_field.dart';

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
                      return CustomProgressIndicator(
                        color: true,
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: (snapshot.data as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            visualDensity: VisualDensity.compact,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl'],
                              ),
                              radius: 30,
                            ),
                            title: SmallText(
                              textAlign: TextAlign.left,
                              text: (snapshot.data! as dynamic).docs[index]
                                  ['userName'],
                            ),
                            subtitle: SmallText(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              textAlign: TextAlign.left,
                              text: (snapshot.data! as dynamic).docs[index]
                                  ['bio'],
                            ),
                            onTap: () {},
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
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 210,
                            width: 200,
                            child: Image.network(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl'],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
