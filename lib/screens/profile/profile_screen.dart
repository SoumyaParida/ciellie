import 'dart:async';

import 'package:Ciellie/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:Ciellie/screens/profile/edit_image.dart';
import 'package:Ciellie/screens/profile/edit_phone.dart';

import 'package:Ciellie/models/user.dart';

import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';

import 'package:Ciellie/network/prefs/profile_share_prefs.dart';

import 'package:Ciellie/widgets/display_image_widget.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  final String newphone;
  final User? uservalue;
  const ProfilePage({Key? key, required this.uservalue, required this.newphone}) : super(key: key);
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
    String phone = widget.newphone;
    //UserProfile profile = widget.newprofile!;

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
                navigateSecondPage(EditImagePage(email:userData.email, image: profile.image));
              },
              child: DisplayImage(
                imagePath: profile.image,
                onPressed: () {},
              )),
          showConstantDetails(userData.username, 'Name'),
          showConstantDetails(userData.email, 'Email'),
          buildUserInfoDisplay(userData.email,phone, 'Phone'),
          
          /*Expanded(
            child: buildAbout(profile),
            flex: 4,
          )*/
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String email,String phone, String title) =>
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
                              navigateSecondPage(EditPhoneFormPage(email:email, phone: phone));
                            },
                            child: Text(
                              phone,
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

  // Widget builds the display item with the proper formatting to display the user's info
  Widget showConstantDetails(String getValue, String title) =>
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
                      
                        child: Text(
                              getValue,
                              style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
                            )),
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