import 'package:flutter/material.dart';
import '../widgets/widget.dart';

class MyUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soumya'),
      ),
      body: Center(
        child: Image(
                      image:
                          AssetImage('assets/images/avatar.png'),
                    ),
      ),
    );
  }
}