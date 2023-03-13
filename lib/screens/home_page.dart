import 'package:flutter/material.dart';
import '../widgets/widget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Surveys'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text('Side Menu Tutorial'),
      ),
    );
  }
}