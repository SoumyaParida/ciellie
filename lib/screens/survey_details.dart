import 'package:Ciellie/screens/survey_data_collect.dart';
import 'package:flutter/material.dart';

class SurveyDetails extends StatefulWidget {
  const SurveyDetails({Key? key}) : super(key: key);

  @override
  _SurveyDetailsState createState() => _SurveyDetailsState();
}

class _SurveyDetailsState extends State<SurveyDetails> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _propertyType;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // do something with the form data
      print('Name: $_name');
      print('Email: $_email');
      print('Phone Number: $_phoneNumber');
      print('Address: $_address');
      print('Property Type: $_propertyType');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.white,
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address (Street, City, State, Zip)',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your property type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Property Type (Residential/Commercial)',
                    filled: true,
                    fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your property type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _propertyType = value;
                },
              ),
              const SizedBox(height: 10),


              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the form data before navigating to the next screen
                      _formKey.currentState!.save();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyDataCollect(final_address: _address!),
                        ),
                      );
                    }
                  },
                  child: const Text('Begin Survey!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

