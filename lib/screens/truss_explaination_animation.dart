import 'package:Ciellie/screens/attic_data_collect.dart';
import 'package:flutter/material.dart';

import '../models/profile.dart';

class TrussInfoPage extends StatefulWidget {
  final UserProfile profile;
  final String address;

  TrussInfoPage({required this.profile, required this.address});
  @override
  _TrussInfoPageState createState() => _TrussInfoPageState();
}

class _TrussInfoPageState extends State<TrussInfoPage>{
  @override
  Widget build(BuildContext context) {
    UserProfile userprofile = widget.profile;
    String address = widget.address;
    return Scaffold(
      appBar: AppBar(
        title: Text('Truss Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.house_siding,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'What is a truss?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '''A truss is a structural framework that is designed to support and distribute loads over a wide area. It is typically made up of a series of interconnected triangles that provide a strong and stable structure. Trusses are commonly used in roof construction and can be identified by their distinct shape and pattern of interconnecting members.
                
You will be taking images and measurements of the truss/rafters.
                ''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDataCollect(userprofile: userprofile, address: address, title: "Attic"),
                  ),
                );
              },
              child: Text(
                'Got It!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
