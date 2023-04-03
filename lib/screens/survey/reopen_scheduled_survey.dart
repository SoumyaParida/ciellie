import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/models/survey.dart';
import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/screens/survey/survey_name.dart';
import 'package:Ciellie/screens/survey_data_collect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Ciellie/constants.dart';

import 'package:intl/intl.dart';
import 'package:time_slot/time_slot.dart';

import 'package:time_slot/controller/day_part_controller.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';
import 'package:time_slot/time_slot_from_list.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:Ciellie/network/db/db_helper.dart';

import 'package:Ciellie/network/prefs/shared_prefs.dart';

class SchduledSurveyReopen extends StatefulWidget {
  final User? profileId;
  final String documentId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String propertyType;
  final String date;
  final String time;
  final String message;
  final String geolocation;
  final String status;
  final UserProfile? userprofile;
  final String uuid;

  const SchduledSurveyReopen({Key? key, required this.documentId ,
                                required this.profileId,
                                required this.name,
                                required this.email,
                                required this.phone,
                                required this.address,
                                required this.propertyType,
                                required this.date,
                                required this.time,
                                required this.message,
                                required this.status,
                                required this.geolocation,
                                required this.userprofile,
                                required this.uuid,
                      }) : super(key: key);

  @override
  _SchduledSurveyReopenState createState() => _SchduledSurveyReopenState();
}

class _SchduledSurveyReopenState extends State<SchduledSurveyReopen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController(); 
  TextEditingController textarea = TextEditingController();
  final _dbHelper = DbHelper.instance;

  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;

  String _currentAddress = "";
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          print("position{$position}");
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /*CollectionReference surveys = FirebaseFirestore.instance.collection("surveys").doc(profileId).collection("survey");

  FutureBuilder<DocumentSnapshot>(
      future: surveys.doc(documentId).get(),
      builder: ((context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = 
                    snapshot.data!.data() as Map<String, dynamic>;}
  */
  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _propertyType;
  String? _date;
  String? _time;
  String? _message;

  User? user;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    dateController.text ="";
    timeinput.text = ""; //set the initial value of text field
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // do something with the form data
      print('Name: $_name');
      print('Email: $_email');
      print('Phone Number: $_phoneNumber');
      print('Address: $_address');
      print('Property Type: $_propertyType');
      print('Date: $_date');
      print('Time: $_time');
      print('Message: $_message');
    }
  }

  Future getSurveyName(String docId) async{
    DocumentSnapshot<Map<String, dynamic>> survey = await _db.collection("surveys").doc(user!.id).collection("survey").
                      doc(docId).get();
    return Text("${survey['address']}");
  }

  @override
  Widget build(BuildContext context) {
    User profile = widget.profileId!;
    String docId = widget.documentId;

    String name = widget.name;
    String email = widget.email;
    String phone = widget.phone;
    String address = widget.address;
    String propertyType = widget.propertyType;
    String date = widget.date;
    String time = widget.time;
    String message = widget.message;
    String status = widget.status;
    String geolocation = widget.geolocation;

    UserProfile userprofile = widget.userprofile!;
     String uuid = widget.uuid;

    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(address.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
               initialValue: name.toString(),
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Name",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
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
              initialValue: email.toString(),
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Email",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  ),
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
               initialValue: phone.toString(),
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Phone Number",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
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
                initialValue: address.toString(),
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Address (Street, City, State, Zip)",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
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
                initialValue: propertyType.toString(),
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Property Type (Residential/Commercial)",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
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
            SizedBox(
                      height: 20,
                    ),
            TextField(
              
              style: TextStyle(
                      fontSize: 16.0,
                      //fontWeight: FontWeight.normal,
                      color: Colors.white60,
                    ),
              
              controller: TextEditingController()..text = date,
              onChanged: (dateController) => {}, //editing controller of this TextField
              //decoration: const InputDecoration( 
              //          icon: Icon(Icons.calendar_today), //icon of text field
              //        labelText: "Enter Date" //label text of field
              //  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Date",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  ),
                  
              readOnly: true,  // when true user cannot edit text 
              onTap: () async {
                      //when click we have to show the datepicker
                      DateTime? pickedDate = await showDatePicker(
                      context: context,
                       initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                  if(pickedDate != null ){
                      print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                      print(formattedDate); //formatted date output using intl package =>  2022-07-04
                        //You can format date as per your need

                      setState(() {
                         dateController.text = formattedDate.toString(); 
                        date = formattedDate.toString();//set foratted date to TextField value. 
                    });
                  }
                  else{
                    _date = date;
                    print("date is not selected");
                  }},
                 
                  
      ),
      SizedBox(
                height: 20,
      ),
      TextField(
              style: TextStyle(
                      fontSize: 16.0,
                      //fontWeight: FontWeight.normal,
                      color: Colors.white60,
                    ),
              
              controller: TextEditingController()..text = time,
              onChanged: (timeinput) => {}, //editing controller of this TextField
              //decoration: const InputDecoration( 
              //          icon: Icon(Icons.calendar_today), //icon of text field
              //        labelText: "Enter Date" //label text of field
              //  ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  //icon: Icon(Icons.timer), //icon of text field
                  hintText: "Enter Time",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  ),
              //readOnly: true,  // when true user cannot edit text 
              
              onTap: () async {
                      TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      print(pickedTime.format(context));   //output 10:51 PM
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      //converting to DateTime so that we can further format on different pattern.
                      print(parsedTime); //output 1970-01-01 22:53:00.000
                      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                      print(formattedTime); //output 14:59:00
                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                      setState(() {
                        timeinput.text = formattedTime.toString();
                        //_time =  formattedTime.toString();//set the value of text field. 
                        time = formattedTime.toString();
                      });
                  }else{
                      print("Time is not selected");
                  }},
      ),
      SizedBox(
                height: 20,
      ),

      TextFormField(
        style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
                      controller: textarea,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Remarks",
                  hintStyle: kBodyText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Remarks';
                  }
                  return null;
                },
                onSaved: (value) {
                  _message = value;
                },
                       
                   ),
             SizedBox(
                      height: 20,
                    ),


              Container(
                height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                child: TextButton(
                  style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black12,
                        ),
                      ),
                     // onPressed: null,
                  onPressed: () {
                    _getCurrentPosition();
                    if (_formKey.currentState!.validate()) {
                      // Save the form data before navigating to the next screen
                      _formKey.currentState!.save();
                      //String id = DateTime.now().millisecondsSinceEpoch.toString() ;
                      updatSurveyModel(docId, profile.id, _name!, _email!, _phoneNumber!,_address!, _propertyType!, date, time, _message!, 'incomplete');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyDataCollect(final_address: _currentAddress, profileId: userprofile, uuid: uuid),
                        ),
                        
                      );
                    }
                  },
                  child: Text(
                        "Begin Survey!",
                        style: kButtonText.copyWith(color: Colors.blue, fontSize: 20.0,fontWeight: FontWeight.bold),
              
                      ),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> updatSurveyModel(String docID ,String id, String name, String email, String phone, String address, String propertyType, 
                        String date, String time, String message, String status) async {
    print("docID{$docID}");
    
    final snapshot =
        await _db.collection("surveys").doc(id).collection("survey").where("id", isEqualTo: docID).get();
    if (snapshot.docs.isNotEmpty){
      final userProfileToCreate = { name: name, email: email, 
                                    phone:phone ,address: address,
                                    propertyType: propertyType,  
                                    date: date, 
                                    time: time,
                                    message:message,
                                    status: status
                                  };
      
      await _db.collection("profiles").doc(id).collection("survey").doc(id).update(userProfileToCreate);
    }
      //final userProfileToCreate = Survey(id: id, name: name, email: email, phone:phone ,address: address,
      //                                propertyType: propertyType,  date: date, time: time,message:message,geolocation: _currentAddress ,status: status);
      //await _dbHelper.createSurvey(userProfileToCreate);
  }
}

