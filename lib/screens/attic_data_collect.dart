import 'package:Ciellie/screens/survey_data_collect.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'Utility.dart';
import 'package:Ciellie/util/Utility.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/profile.dart';

class AppDataCollect extends StatefulWidget {
  final UserProfile userprofile;
  final String address;
  final String title;
  AppDataCollect({required this.userprofile, required this.address, required this.title});

  @override
  State<AppDataCollect> createState() => _AppDataCollectState();
}

class _AppDataCollectState extends State<AppDataCollect> {
  Future<File>? imageFile;
  Image? imageFromPreferences;
  bool _load = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];
  List<File> imagePaths = [];

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      //imageFile = ImagePicker.pickImage(source: source) as Future<File>;
      imageFile = ImagePicker.platform.pickImage(source: source) as Future<File>;
      _load = false;
    });
  }

Future<void> saveImageInfirestore(String id, List<File> images, String title) async {
      print(id);
      for (int i = 0; i < images.length; i++) {
        File imagePath = images[i];
        final metadata = SettableMetadata(contentType: "image/jpeg");
        Reference ref = FirebaseStorage.instance.ref()
                    .child(title).child(id)
                    .child('profile_${i}.jpg');
        //if (imagePath.existsSync()) imagePath = await imagePath.create();
        UploadTask uploadTask = ref.putFile(imagePath);
        final snapshottask = await uploadTask.whenComplete(() => null);
        final imageUrl = await snapshottask.ref.getDownloadURL();
        print("imageUrl{$imageUrl}");
      }
  }

  /*Future<void> saveImageInfirestore(String id, File imagePath) async {
    final metadata = SettableMetadata(contentType: "image/jpeg");
    Reference ref = FirebaseStorage.instance.ref()
                .child("attic")
                .child('profile_${id}.jpg');
    UploadTask uploadTask = ref.putFile(imagePath);
    final snapshottask = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshottask.ref.getDownloadURL();
    print("imageUrl{$imageUrl}");
    final result=_db.collection("profiles").doc(id).update({"image":imageUrl});
    print("result{$result}");
    return;
  }*/

  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (null == snapshot.data) {
            return const Text(
              "Error",
              textAlign: TextAlign.center,
            );
          }
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data!.readAsBytesSync()));
          return Image.file(snapshot.data!);
        }
        if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        }
        return const Text(
          'No Image Selected',
          textAlign: TextAlign.center,
        );
      },
    );
  }
  Widget build(BuildContext context) {
    UserProfile profile = widget.userprofile;
    String address = widget.address;
    String title = widget.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery(ImageSource.gallery);
              setState(() {
                imageFromPreferences;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadImageFromPreferences();
            },
          ),
        ],*/
      ),
      body: SafeArea(
        child: 
          Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  selectImage();
                },
                child: const Text(
                  "Select Image",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  
                  ),
                  
                ),
                Expanded(
                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                    itemCount: _imageList.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.file(
                                              File(_imageList[index].path),
                                              fit: BoxFit.cover,
                                            ),

                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                color: Color.fromRGBO(0, 0, 0, 0.7),
                                                child: IconButton(
                                                  onPressed: (){
                                                    _imageList.removeAt(index);
                                                    setState(() {
                                                      
                                                    });
                                                  },
                                                  icon: Icon(Icons.close),
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                  }
                  ),
                ),
                SizedBox(height: 20,),
                  ElevatedButton(
              onPressed: () async {
                //user = user.copy(imagePath: newImage.path));
                      
                await saveImageInfirestore(profile.id, imagePaths, title);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurveyDataCollect(profileId: profile, final_address: address),
                  ),
                );
              },
              child: Text(
                'Upload Images!',
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
      )
      )
    );
  }

  Future<void> selectImage() async {

    final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final location = await getApplicationDocumentsDirectory();
    final name = image.path.split('/').last;
    final imageFile = File('${location.path}/$name');
                      

    /*final XFile? selected_image = 
          await _picker.pickImage(source: ImageSource.gallery);
    if(selected_image!.path.isNotEmpty){
      _imageList.add(selected_image);
    */
      imagePaths.add(imageFile);
    
    //print(selected_image!.path.toString());
    setState((){});
  }
}
