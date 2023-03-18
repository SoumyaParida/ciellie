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

class NavDrawer extends StatefulWidget {
  final User? user;
  const NavDrawer({Key? key, required this.user}) : super(key: key);
  //const NavDrawer({Key? key}) : super(key: key);
  
  @override
  _NavDrawerScreenState createState() => _NavDrawerScreenState();
}
class _NavDrawerScreenState extends State<NavDrawer> {
  final authenticator = Authenticator.instance;
  @override
  Widget build(BuildContext context) {
    final profile = UserData.myUser;
    User userData = widget.user!;
    String name = "";
    String email = "";
    String imagePath = "";
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

    imagePath = profile.image;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, name, email, imagePath),
            buildMenuItems(context),
          ],
        )
        ),
    );
  }
  
  Widget buildHeader(BuildContext context, String name, String email, String imagePath) => Material(
    color: Colors.blue.shade700,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(uservalue: widget.user!),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(children: [
          CircleAvatar(
                radius: 52,
                child: DisplayImage(
                  imagePath: imagePath,
                onPressed: () {},
                ),
              ),
          SizedBox(height: 12),
          ListTile(
            title: Text(name),
            subtitle: Text(email),
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
    
}