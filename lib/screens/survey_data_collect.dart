import 'package:Ciellie/screens/attic_data_collect.dart';
import 'package:Ciellie/screens/truss_explaination_animation.dart';
import 'package:flutter/material.dart';

class SurveyDataCollect extends StatefulWidget {
  final String final_address;

  const SurveyDataCollect({Key? key, required this.final_address}) : super(key: key);

  @override
  State<SurveyDataCollect> createState() => _SurveyDataCollectState();
}

class _SurveyDataCollectState extends State<SurveyDataCollect> {
  late String _finalAddress;

  final List<String> _details = [
    'Ladder',
    'Measuring Tape',
    'Flashlight'
  ];

  @override
  void initState() {
    super.initState();
    _finalAddress = widget.final_address;
    print("_finalAddress{$_finalAddress}");
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.final_address;
    print("address{$address}");
    return Scaffold(
      appBar: AppBar(
        title: Text(_finalAddress),
      ),
      body: Center(
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
                          builder: (context) => TrussInfoPage(),
                        ),
                      );
                    },
                    child: Text('Take Images'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            _buildStepCard(
              stepNumber: '2',
              stepTitle: 'Electrical',
              stepDetails: '- voltage tester\n- wire cutter\n- electrical tape',
            ),
            SizedBox(height: 20.0),
            _buildStepCard(
              stepNumber: '3',
              stepTitle: 'Appliances',
              stepDetails: '- refrigerator\n- stove\n- dishwasher',
            ),
            SizedBox(height: 20.0),
            _buildStepCard(
              stepNumber: '4',
              stepTitle: 'Roof',
              stepDetails: '- ladder\n- hammer\n- roofing nails',
            ),
            SizedBox(height: 20.0),
            _buildStepCard(
              stepNumber: '5',
              stepTitle: 'Extra Details',
              stepDetails: '- paint color\n- flooring type\n- wall texture',
            ),
          ],
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