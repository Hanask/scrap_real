// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap_real/utils/firestore_methods.dart';
import 'package:scrap_real/utils/storage_methods.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/button_widgets/custom_textbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_biocard.dart';
import 'package:scrap_real/widgets/card_widgets/custom_namecard.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:scrap_real/widgets/profile_widgets/custom_profile2.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  Uint8List? file;
  String imgPath = "";
  String? photoUrl;
  bool isLoading = true;

  var userData = {};
  final user = FirebaseAuth.instance.currentUser!;
  final docId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _name.dispose();
    _bio.dispose();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      photoUrl = userSnap['photoUrl'];
      userData = userSnap.data()!;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
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
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && !isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomBackButton(buttonFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSettingsPage(),
                          ),
                        );
                      }),
                      CustomHeader(headerText: "Edit Profile"),
                      CustomProfilePicture2(
                        // path: imgPath,
                        context: context,
                        profileFunction1: () {
                          takePhoto(ImageSource.camera);
                        },
                        profileFunction2: () {
                          takePhoto(ImageSource.gallery);
                        },
                        photoUrl: photoUrl,
                        alt: "assets/images/profile.png",
                      ),
                      const SizedBox(height: 7),
                      CustomSubheader(
                        headerText: "Edit",
                        headerSize: 20,
                        headerColor: const Color(0xffa09f9f),
                      ),
                      const SizedBox(height: 20),
                      CustomNameCard(
                        textName: "Username",
                        hintingText: "Enter Username",
                        textController: _username,
                        validatorFunction: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomNameCard(
                        textName: "Name",
                        hintingText: "Enter Name",
                        textController: _name,
                        validatorFunction: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBioCard(
                        textController: _bio,
                        textColor: const Color(0xffa09f9f),
                      ),
                      const SizedBox(height: 30),
                      CustomTextButton(
                        buttonBorderRadius: BorderRadius.circular(35),
                        buttonFunction: updateProfile,
                        buttonText: "Save",
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    try {
      // image
      Uint8List im = await StorageMethods().selectImage(source);
      setState(() => file = im);

      // image path
      final path = await StorageMethods().selectTempImage(source);
      setState(() => imgPath = path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void updateProfile() {
    FireStoreMethods().updateProfile(
      docId,
      _username.text,
      _name.text,
      _bio.text,
      file,
      photoUrl,
      mounted,
      context,
    );
  }
}