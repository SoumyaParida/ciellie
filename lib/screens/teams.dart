import 'package:flutter/material.dart';
import '../widgets/widget.dart';

class MyTeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: Center(
        child: Text('Side Menu Tutorial'),
      ),
    );
  }
}