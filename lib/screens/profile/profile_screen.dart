import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Ciellie/screens/profile/edit_description.dart';
import 'package:Ciellie/screens/profile/edit_email.dart';
import 'package:Ciellie/screens/profile/edit_image.dart';
import 'package:Ciellie/screens/profile/edit_name.dart';
import 'package:Ciellie/screens/profile/edit_name.dart';
import 'package:Ciellie/screens/profile/edit_phone.dart';

import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/models/profile.dart';

import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';

import 'package:Ciellie/network/prefs/profile_share_prefs.dart';

import 'package:Ciellie/widgets/display_image_widget.dart';
//import '../user/user.dart';
//import '../widgets/display_image_widget.dart';
//import '../user/user_data.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  final User? uservalue;
  const ProfilePage({Key? key, required this.uservalue}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DbHelper.instance;
  User? user;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getInstance().then((prefs) {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      print("user: $user");
      setState(() => isInitialDataFetched = true);
      //super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final userdata = this.user;
    //User userdata = widget.userdata!;
    //User userdata = this.user!;
    final profile = UserData.myUser;
    //User userData = widget.user!;
    User userData = widget.uservalue!;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
                  ))),
          InkWell(
              onTap: () {
                navigateSecondPage(EditImagePage());
              },
              child: DisplayImage(
                imagePath: profile.image,
                onPressed: () {},
              )),
          buildUserInfoDisplay(profile.name, 'Name', EditNameFormPage()),
          buildUserInfoDisplay(profile.phone, 'Phone', EditPhoneFormPage()),
          buildUserInfoDisplay(profile.email, 'Email', EditEmailFormPage()),
          Expanded(
            child: buildAbout(profile),
            flex: 4,
          )
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the About Me Section
  Widget buildAbout(UserProfile userprofile) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          navigateSecondPage(EditDescriptionFormPage());
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  userprofile.aboutMeDescription,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ))))),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}