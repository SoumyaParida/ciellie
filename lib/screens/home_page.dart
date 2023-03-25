import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/screens/survey_details.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import '../screens/screen.dart';

import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget
{
  const MyHomePage({Key? key}) : super(key: key);
  
  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePage> {
  final dbHelper = DbHelper.instance;
  User? user;
  UserProfile? userProfile;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getInstance().then((prefs) async {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      print("user: $user");
      final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: user!.email).get();
      userProfile = UserProfile.fromJson(snapshot.docs.first.data());
      setState(() => isInitialDataFetched = true);
      //super.initState();
    });
  }

  //late User user;
  //late SharedPrefs sharedPrefs;
  //var isInitialDataFetched = false;
  Widget build(BuildContext context) {
    //SharedPrefs sharedPrefs = dbHelper.
    //var userData = widget.user;
    //print("user inside: $user");
    //var uservalue = this.user ?? '';

    return Scaffold(  
      drawer: NavDrawer(user: this.user, userProfile : this.userProfile),
      appBar: AppBar(
        title: Text('Surveys'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Text('Begin New Survey'),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SurveyDetails(userProfile : this.userProfile)));
            //MaterialPageRoute(builder: (context) => SurveyListScreen()));
      },
      child: Icon(Icons.add),
      ),
    );
  }
}