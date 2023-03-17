//import 'package:Ciellie/screens/survey_details.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import '../screens/screen.dart';

import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';

class MyHomePage extends StatefulWidget
{
  const MyHomePage({Key? key}) : super(key: key);
  
  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePage> {
  final dbHelper = DbHelper.instance;
  late User user;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getInstance().then((prefs) {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      setState(() => isInitialDataFetched = true);
      super.initState();
    });
  }

  //late User user;
  //late SharedPrefs sharedPrefs;
  //var isInitialDataFetched = false;
  Widget build(BuildContext context) {
    //SharedPrefs sharedPrefs = dbHelper.
    
    return Scaffold(
      drawer: NavDrawer(user: user),
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
            //MaterialPageRoute(builder: (context) => SurveyDetails()));
            MaterialPageRoute(builder: (context) => SurveyListScreen()));
      },
      child: Icon(Icons.add),
      ),
    );
  }
}