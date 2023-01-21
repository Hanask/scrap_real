// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_usercard.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbooklarge.dart';
import 'package:scrap_real/widgets/selection_widgets/custom_selectiontab3.dart';
import 'package:scrap_real/widgets/text_widgets/custom_searchfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool users = true;
  bool search = true;
  String _searchQuery = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.of(context).pop();
                }),
                SizedBox(height: 20),
                CustomSearchField(
                  // validatorFunction: (query) =>
                  //     (query != null && query.length < 6)
                  //         ? 'Enter a min. of 6 characters'
                  //         : null,
                  hintingText:
                      users ? "Search for a user" : "Search for a scrapbook",
                  onChangedFunc: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomSelectionTab3(
                  selection: users,
                  selection1: "Users",
                  selecion2: "Scrapbooks",
                  func1: () {
                    if (users == false) {
                      setState(() {
                        users = true;
                      });
                    }
                  },
                  func2: () {
                    if (users == true) {
                      setState(() {
                        users = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 1),
                users ? usersView() : scrapbooksView(),
                // usersView2(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usersView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return (snapshots.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;

                  if (_searchQuery.isEmpty) {
                    return CustomUserCard(
                      photoUrl: data['photoUrl'],
                      alt: "assets/images/profile.png",
                      username: data['username'],
                      onTapFunc: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            uid: (snapshots.data! as dynamic).docs[index]
                                ['uid'],
                            implyLeading: search,
                          ),
                        ),
                      ),
                    );
                  }
                  if (data['username']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchQuery.toLowerCase())) {
                    return CustomUserCard(
                      photoUrl: data['photoUrl'],
                      alt: "assets/images/profile.png",
                      username: data['username'],
                      onTapFunc: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            uid: (snapshots.data! as dynamic).docs[index]
                                ['uid'],
                            implyLeading: search,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }

  Widget scrapbooksView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('scrapbooks').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return (snapshots.connectionState == ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;

                  if (_searchQuery.isEmpty) {
                    return Column(
                      children: [
                        CustomScrapbookLarge(
                          scrapbookId: data['scrapbookId'],
                          title: data['title'],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }
                  if (data['title']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchQuery.toLowerCase())) {
                    return Column(
                      children: [
                        CustomScrapbookLarge(
                          scrapbookId: data['scrapbookId'],
                          title: data['title'],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }
}