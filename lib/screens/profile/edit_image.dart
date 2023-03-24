import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Ciellie/network/prefs/profile_share_prefs.dart';
//import 'package:flutter_user_profile/user/user_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:Ciellie/widgets/appbar_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/constants.dart';

class EditImagePage extends StatefulWidget {
  final String? email;
  final String? image;
  const EditImagePage({Key? key, required this.email, required this.image}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  String imageUrl = "";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void pickUploadImage() async {
    final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

    Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value){
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: (){
                      pickUploadImage();
                    },
                    /*onTap: () async {
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
                    },
                    child: Image.network(user.image),*/
                    child: imageUrl == " " ? Icon(
                      Icons.person, size: 80,color: Colors.white,
                      ): Image.network(imageUrl),
                  ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () =>onClickButton(context, imageUrl) ,
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
  Future<void> onClickButton(BuildContext context, String phone) async {
    String email = widget.email!;
    print(email);
    final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty){
      var doc_id = snapshot.docs.first.id;
      await _db.collection("profiles").doc(doc_id).update({"phone":phone});
    }
    else{
      print("test");
    }
    return;
  }
}