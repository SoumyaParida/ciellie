import 'dart:async';
import 'dart:io';

import 'package:Ciellie/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:Ciellie/screens/profile/edit_image.dart';
import 'package:Ciellie/screens/profile/edit_phone.dart';

import 'package:Ciellie/models/user.dart';

import 'package:Ciellie/network/db/db_helper.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';

import 'package:Ciellie/network/prefs/profile_share_prefs.dart';

import 'package:Ciellie/widgets/display_image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//import 'package:path/path.dart';


// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  final String newphone;
  final String newimage;
  final User? uservalue;
  const ProfilePage({Key? key, required this.uservalue, required this.newphone, required this.newimage}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DbHelper.instance;
  User? user;
  late SharedPrefs sharedPrefs;
  var isInitialDataFetched = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  

  @override
  void initState() {
    super.initState();
    SharedPrefs.getInstance().then((prefs) {
      sharedPrefs = prefs;
      user = sharedPrefs.getUser()!;
      print("user: $user");
      setState(() => isInitialDataFetched = true);
      //super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final userdata = this.user;
    //User userdata = widget.userdata!;
    //User userdata = this.user!;
    final profile = UserData.myUser;
    //User userData = widget.user!;
    User userData = widget.uservalue!;
    String phone = widget.newphone;
    String image = widget.newimage;
    
    if (profile.phone == ""){
        profile.phone = phone;
    }

    if ((profile.image == "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg")
      && (image != ""))
    {
      profile.image = image;
    }

    Future<void> saveImageInfirestore(File imagePath) async {
    String email = userData.email;
    print(email);
    final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty){
      var doc_id = snapshot.docs.first.id;
      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");
      Reference ref = FirebaseStorage.instance.ref()
                  .child("avatar")
                  .child('profile_${doc_id}.jpg');
      UploadTask uploadTask = ref.putFile(imagePath);
      final snapshottask = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshottask.ref.getDownloadURL();
      print("imageUrl{$imageUrl}");
      final result=_db.collection("profiles").doc(doc_id).update({"image":imageUrl});
      profile.image = imageUrl;
      print("result{$result}");
      return;
    }
    return;
    
  }

  Future<String> getProfileImage(String email) async{
      try{
        final snapshot =
          await _db.collection("profiles").where("email", isEqualTo: email).get();
        var image = snapshot.docs.first.get("image");
        if(image == ""){
          image = "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg";
        }
        setState(() {});
        return image;
      } catch (e) {
        print(e);
        return "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg";
      }
  }

    //UserProfile profile = widget.newprofile!;

    return Scaffold(
      
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
                  ))),
          InkWell(
              onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (image == null) return;

                      final location = await getApplicationDocumentsDirectory();
                      final name = image.path.split('/').last;
                      final imageFile = File('${location.path}/$name');
                      final newImage =
                          await File(image.path).copy(imageFile.path);
                      setState(
                          () => profile.image = newImage.path); //user = user.copy(imagePath: newImage.path));
                      
                    await saveImageInfirestore(imageFile);
                                         },
              
              /*child: DisplayImage(
                imagePath: profile.image != "" ? profile.image : "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
                onPressed: () {},
              );*/
              child: FutureBuilder<String>(
            future: getProfileImage(userData.email),
            builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();

            if(snapshot.data!.isNotEmpty){
              String data = snapshot.data as String;
              return CircleAvatar(
                    radius: 52,
                    child: DisplayImage(
                      imagePath: data,
                      onPressed: (){
                        //setState(() {});
                      },
                      
                    ),
                  );
            }
            else {
                          print("List Null");
                          return Text("");
            }
            }
          ),
   ),
          showConstantDetails(userData.username, 'Name'),
          showConstantDetails(userData.email, 'Email'),
          buildUserInfoDisplay(userData.email,profile.phone, 'Phone'),
          
          /*Expanded(
            child: buildAbout(profile),
            flex: 4,
          )*/
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String email,String phone, String title) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(EditPhoneFormPage(email:email, phone: phone));
                            },
                            child: Text(
                              phone,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the display item with the proper formatting to display the user's info
  Widget showConstantDetails(String getValue, String title) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                      
                        child: Text(
                              getValue,
                              style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
                            )),
                  ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}