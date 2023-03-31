import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/screens/attic_data_collect.dart';
import 'package:Ciellie/screens/truss_explaination_animation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'package:Ciellie/network/db/db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class SurveyDataCollect extends StatefulWidget {
  final String final_address;
  final UserProfile profileId;

  const SurveyDataCollect({Key? key, required this.final_address, required this.profileId}) : super(key: key);

  @override
  State<SurveyDataCollect> createState() => _SurveyDataCollectState();
}

class _SurveyDataCollectState extends State<SurveyDataCollect> {
  User? usernew;
  late String _finalAddress;
  //late User user;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<String> _details = [
    'Ladder',
    'Measuring Tape',
    'Flashlight'
  ];

  Future<User?> getUser(String userId) async {
    try{
      final snapshot = await _db.collection("users").doc(userId).get();

      var ProfileValues = snapshot.data();
      ProfileValues!['id'] = userId;
      usernew = User.fromJson(ProfileValues);
      return usernew;
    } catch (e) {
      print(e);
      return null;
    }
  
  }

  @override
  void initState() {
    super.initState();
    _finalAddress = widget.final_address;
    print("_finalAddress{$_finalAddress}");
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.final_address;
    final profile = widget.profileId;
    print("address{$address}");
    return Scaffold(
      appBar: AppBar(
        title: Text(_finalAddress),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.45 * 1.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Step 1: Attic',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('- ladder', style: TextStyle(fontSize: 16.0)),
                        Text('- measuring tape', style: TextStyle(fontSize: 16.0)),
                        Text('- flashlight', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrussInfoPage(profile: profile, address: address),
                          ),
                        );
                      },
                      child: Text('Take Images'),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.0),
              Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.width * 0.45 * 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step 2: Electrical',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('- voltage tester', style: TextStyle(fontSize: 16.0)),
                        Text('- wire cutter', style: TextStyle(fontSize: 16.0)),
                        Text('- electrical tape', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                        SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDataCollect(userprofile: profile, address: address, title: "Electrical"),
                          ),
                        );
                      },
                      child: Text('Take Images'),
                    ),
                      ],
                    ),
                  ),
              SizedBox(height: 20.0),
              Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.45 * 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step 3: Appliances',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('- refrigerator', style: TextStyle(fontSize: 16.0)),
                        Text('- stove', style: TextStyle(fontSize: 16.0)),
                        Text('- dishwasher', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                        SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDataCollect(userprofile: profile, address: address, title: "Appliances"),
                          ),
                        );
                      },
                      child: Text('Take Images'),
                    ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.45 * 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step 4: Roof',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('- ladder', style: TextStyle(fontSize: 16.0)),
                        Text('- hammer', style: TextStyle(fontSize: 16.0)),
                        Text('- roofing nails', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                        SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDataCollect(userprofile: profile, address: address, title: "Roof"),
                          ),
                        );
                      },
                      child: Text('Take Images'),
                    ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.45 * 1.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step 5: Extra Details',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('- paint color', style: TextStyle(fontSize: 16.0)),
                        Text('- flooring type', style: TextStyle(fontSize: 16.0)),
                        Text('- wall texture', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                        SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDataCollect(userprofile: profile, address: address, title: "ExtraDetails"),
                          ),
                        );
                      },
                      child: Text('Take Images'),
                    ),
                      ],
                    ),
                  ),
              SizedBox(height: 20.0),
              ElevatedButton(
              onPressed: () async {
                User? user = await getUser(profile.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(currentuser: user),
                  ),
                );
              },
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String stepTitle,
    required String stepDetails,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75 / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Step $stepNumber: $stepTitle',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}