import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/screens/gps.dart';
import 'package:Ciellie/screens/screen.dart';
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
  const NavDrawer({Key? key, required this.user}) : super(key: key);
  //const NavDrawer({Key? key}) : super(key: key);
  
  @override
  _NavDrawerScreenState createState() => _NavDrawerScreenState();
}
class _NavDrawerScreenState extends State<NavDrawer> {
  final authenticator = Authenticator.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserProfile? targetprofile;
  
  @override
  Widget build(BuildContext context) {
    //final profile = UserData.myUser;
    User userData = widget.user!;
    //Future<UserProfile?> _profile = onClickButton(userData.email); 
    //print("_profile {$_profile}");
    
    
    
    String name = "";
    String email = "";
    String phone = "";
    String imagePath = "";

    final profile = UserData.myUser;

    
    /*onClickButton(userData.email).then((val) => setState(() {
          profile = val;
          //print("_profile{$_profile}");
        }));
  */
    
    //print("profile {$profile}");
    
    print("profile{$profile}");
    if (profile.name != ""){
      name = profile.name;
    }
    else{
      name = userData.username;
    }

    if (profile.email != ""){
      email = profile.email;
    }
    else{
      email = userData.email;
    }

    if (profile.phone != ""){
      phone = profile.phone;
    }

    imagePath = profile.image;

    print("profile{$profile}");

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, name, email, phone, imagePath, profile),
            buildMenuItems(context),
          ],
        )
        ),
    );
  }
  
  Widget buildHeader(BuildContext context, String name, String email, String phone, String imagePath, UserProfile profile) => Material(
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
          builder: (context) => ProfilePage(newphone: newprofile!.phone, uservalue: widget.user!),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
          CircleAvatar(
                radius: 52,
                child: DisplayImage(
                  imagePath: imagePath,
                onPressed: () {},
                ),
              ),
          SizedBox(height: 12),
          
          ListTile(
            title: new Center(child: new Text(name,
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 20.0),)),
            //title: Text(name),
            subtitle: new Center(child: new Text(email,
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 15.0),)),
          ),
          
    ]),
  ),
  ),
  );
  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Surveys"),
        onTap: () =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MyHomePage(),
        )),
      ),
      ListTile(
        leading: const Icon(Icons.workspaces_outline),
        title: const Text("Teams"),
        onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyTeamsPage(),
      ));
      },
      ),
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
  }
}