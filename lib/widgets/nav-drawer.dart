import 'dart:async';

import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/screens/gps.dart';
import 'package:Ciellie/screens/screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:Ciellie/screens/profile/profile_screen.dart';

import 'package:Ciellie/network/prefs/shared_prefs.dart';
import 'package:Ciellie/network/auth/authenticator.dart';


import 'package:Ciellie/network/prefs/profile_share_prefs.dart';
import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/widgets/display_image_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/constants.dart';


class NavDrawer extends StatefulWidget {
  final User? user;
  //final UserProfile? userProfile;
  const NavDrawer({Key? key, required this.user}) : super(key: key);
  //const NavDrawer({Key? key}) : super(key: key);
  
  @override
  _NavDrawerScreenState createState() => _NavDrawerScreenState();
}
class _NavDrawerScreenState extends State<NavDrawer> {
  final authenticator = Authenticator.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserProfile? targetprofile;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  @override
  Widget build(BuildContext context) {
    final profile = UserData.myUser;
    User user_data = widget.user!;
    String imagePath = "";
    /*UserProfile userProfileData = widget.userProfile!;
    
    String name = "";
    String email = "";
    String phone = "";
    String imagePath = "";

    final profile = UserData.myUser;
    print("profile{$profile}");
    
    if (profile.name != ""){
      name = profile.name;
    }
    else{
      name = user_data.username;
    }

    if (profile.email != ""){
      email = profile.email;
    }
    else{
      email = user_data.email;
    }

    phone =  userProfileData.phone;

    if (userProfileData.image.contains('https://')){
      imagePath = userProfileData.image;
    }
    else{
      imagePath = profile.image;
    }
    

    print("profile{$profile}");*/
    
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, user_data),
            buildMenuItems(context, user_data),
          ],
        )
        ),
    );
  }

  Future<UserProfile?> getProfile(String email) async{
      final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: email).get();
      targetprofile = UserProfile.fromJson(snapshot.docs.first.data());
      print("userProfile future{$targetprofile}");
      return targetprofile;
  }

  Future<String> getProfileImage(String email) async{
      try{
        final snapshot =
          await _db.collection("profiles").where("email", isEqualTo: email).get();
        var image = snapshot.docs.first.get("image");
        if(image == ""){
          image = "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg";
        }
        return image;
      } catch (e) {
        print(e);
        return "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg";
      }
  }

  //Widget buildHeader(BuildContext context, User user_data) => Material(
  Widget buildHeader(BuildContext context, User user) => Material(
    color: Colors.blue.shade700,
    child: InkWell(
      onTap: () async {
        //UserProfile? profile = onClickButton(context, widget.user!.email) as UserProfile?;
        Future<UserProfile?> stringFuture = onClickButton(widget.user!.email);
        UserProfile? newprofile = await stringFuture;
        print("newpfofile{$newprofile}");
        
        //print("targetprofile{$targetprofile}");
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(uservalue: widget.user!, newphone: newprofile!.phone, newimage: newprofile.image),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            
          FutureBuilder<String>(
            future: getProfileImage(user.email),
            builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();

            if(snapshot.data!.isNotEmpty){
              String data = snapshot.data as String;
              return CircleAvatar(
                    radius: 52,
                    child: DisplayImage(
                      imagePath: data,
                      onPressed: () async {
                      Future<UserProfile?> stringFuture = onClickButton(widget.user!.email);
                      UserProfile? newprofile = await stringFuture;
                      print("newpfofile{$newprofile}");
                      
                      //print("targetprofile{$targetprofile}");
                      Navigator.pop(context);
                      //Navigator.of(context).pushReplacement(ProfilePage(newphone: newprofile!.phone, newimage: newprofile.image, uservalue: widget.user!)),
                      //);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(newphone: newprofile!.phone, newimage: newprofile.image, uservalue: widget.user!),
                        ));
                    },
                    ),
                  );
            }
            else {
                          print("List Null");
                          return Text("");
            }
            }
          ),
          SizedBox(height: 12),
          
          ListTile(
            title: new Center(child: new Text(user.username,
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 20.0),)),
            //title: Text(name),
            subtitle: new Center(child: new Text(user.email,
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 15.0),)),
          ),
          
    ]),
  ),
  ),
  );
  Widget buildMenuItems(BuildContext context, User user) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Surveys"),
        onTap: () =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MyHomePage(currentuser: user),
        )),
      ),
      /*ListTile(
        leading: const Icon(Icons.workspaces_outline),
        title: const Text("Teams"),
        onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyTeamsPage(),
      ));
      },
      ),*/
      ListTile(
        leading: const Icon(Icons.map_outlined),
        title: const Text("Maps"),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen(),
          ));
        },
      ),
      const Divider(color: Colors.black54,),
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Logout"),
        onTap: onClickLogout,
      )
      
    ],
  )
  );

  Future<void> onClickLogout() async {
    await authenticator.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  WelcomePage()));
  }

  Future<UserProfile?> onClickButton(String email) async {
    print("email{$email}");
    try{
      final snapshot =
          await _db.collection("profiles").where("email", isEqualTo: email).get();
      final profile = snapshot.docs.map((e) => UserProfile.fromDocSnapshot(e)).single;
      print("snapshot{$snapshot}");
      var phone = snapshot.docs.first.get("phone");
      var userprofile = snapshot.docs.first.data();
      targetprofile =  UserProfile.fromJson(userprofile);
      print("phone{$phone}");
      print("userprofile{$userprofile}");
      print("targetprofile1{$targetprofile}");
      return targetprofile;
    } catch (e) {
      print(e);
      return targetprofile;
    }

  }

  /*FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }*/

}