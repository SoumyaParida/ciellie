import 'package:Ciellie/screens/survey_details.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import '../screens/screen.dart';

class MyHomePage extends StatelessWidget
{

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
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