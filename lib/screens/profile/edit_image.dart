import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Ciellie/network/prefs/profile_share_prefs.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_user_profile/user/user_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:Ciellie/widgets/appbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditImagePage extends StatefulWidget {
  final String image;
  final String? email;
  const EditImagePage({Key? key, required this.email, required this.image}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  File? image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String imageUrl = "";

  Future pickImage(ImageSource source) async{
    try {
      final image = await ImagePicker().pickImage(source: source); 
      if(image == null) return;

      //final imageTemprary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
      final imageInFirestore = await saveImageInfirestore(imagePermanent);
    }on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

   Future<void> saveImageInfirestore(File imagePath) async {
    String email = widget.email!;
    print(email);
    final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty){
      var doc_id = snapshot.docs.first.id;
      
      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");
      
      // Create a reference to the Firebase Storage bucket
      //final storageRef = FirebaseStorage.instance.ref();

      //final uploadTask = storageRef
      //    .child("profilePictures/profiles_{$doc_id}.jpg")
      //     .putFile(imagePath, metadata);

      Reference ref = FirebaseStorage.instance.ref()
                  .child("avatar")
                  .child('profile_${doc_id}.jpg');
      //UploadTask uploadTask = ref.putFile(imagePath);
      //final snapshottask = await uploadTask.whenComplete(() => null);
      //final urlImageUser = await snapshot.ref.getDownloadURL();
      await ref.putFile(imagePath, metadata);

      //final urlImageUser = await snapshot.ref.getDownloadURL();
      ref.getDownloadURL().then((value) {
        print(value);
        setState(() {
          imageUrl =value;  
        });
      });
      print("imageUrl{$imageUrl}");
      await _db.collection("profiles").doc(doc_id).update({"image":imageUrl});      
    }
    else{
      print("test");
    }
    return;
  }

  Future<File> saveImagePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    
    return File(imagePath).copy(image.path);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: 330,
              child: const Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (image == null) return;

                      final location = await getApplicationDocumentsDirectory();
                      final name = basename(image.path);
                      final imageFile = File('${location.path}/$name');
                      final newImage =
                          await File(image.path).copy(imageFile.path);
                      setState(
                          () => user = user.copy(imagePath: newImage.path));
                          //pickImage(ImageSource.gallery);
                    },
                    
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/ciellie.appspot.com/o/avatar%2Fprofile_zxYahOhy29csZ0ElbWf3272iphb2.jpg?alt=media&token=23099e9a-211c-4a92-b0a5-a0d6d40e4ca1"),
                  ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      
                      child: const Text(
                        'Pick Gallery',
                        
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),)),
                  Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {ImageSource.camera;},
                      child: const Text(
                        'Pick Camera',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),))
        ],
      ),
    );
  }
}