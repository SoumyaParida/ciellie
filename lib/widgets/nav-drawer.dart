import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/screens/gps.dart';
import 'package:Ciellie/screens/screen.dart';
import 'package:flutter/material.dart';

import 'package:Ciellie/network/prefs/shared_prefs.dart';
import 'package:Ciellie/network/auth/authenticator.dart';

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
    User userData = widget.user!;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, userData),
            buildMenuItems(context),
          ],
        )
        ),
    );
  }
  
  Widget buildHeader(BuildContext context, User userData) => Material(
    color: Colors.blue.shade700,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyUsersPage(),
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
                child: Image(
                              image:
                                  AssetImage('assets/images/avatar.png'),
                            ),
              ),
          SizedBox(height: 12),
          ListTile(
            title: Text(userData.username),
            subtitle: Text(userData.email),
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