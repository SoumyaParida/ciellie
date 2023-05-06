import 'package:Ciellie/screens/survey_data_collect.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/profile.dart';

class AppDataCollect extends StatefulWidget {
  final UserProfile userprofile;
  final String address;
  final String title;
  final String uuid;
  AppDataCollect({required this.userprofile, required this.address, required this.title, required this.uuid});

  @override
  State<AppDataCollect> createState() => _AppDataCollectState();
}

class _AppDataCollectState extends State<AppDataCollect> {
  Future<File>? imageFile;
  Image? imageFromPreferences;
  bool _load = false;
  bool isLoading = false;
  

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];

  //late PickedFile image;

  List<File> imagePaths = [];

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      //imageFile = ImagePicker.pickImage(source: source) as Future<File>;
      imageFile = ImagePicker.platform.pickImage(source: source) as Future<File>;
      _load = false;
    });
  }
  

    Future<void> saveImageInfirestore(String id, List<File> images, String title, String uuid) async {
      print(id);
      for (int i = 0; i < images.length; i++) {
        File imagePath = images[i];
        final metadata = SettableMetadata(contentType: "image/jpeg");
        //Reference ref = FirebaseStorage.instance.ref()
        //            .child(title).child(id).child(uuid)
        //            .child('profile_${i}.jpg');
        Reference ref = FirebaseStorage.instance.ref()
                    .child(id).child(uuid).child(title)
                    .child('profile_${i}.jpg');
        UploadTask uploadTask = ref.putFile(imagePath);
        final snapshottask = await uploadTask.whenComplete(() => null);
        final imageUrl = await snapshottask.ref.getDownloadURL();
        print("imageUrl{$imageUrl}");
      }
  }


  Widget build(BuildContext context) {
    UserProfile profile = widget.userprofile;
    String address = widget.address;
    String title = widget.title;
    String uuid = widget.uuid;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                //setState(() { _isLoading = true });//show loader
                showDialog(
                  context: context, 
                  builder: (context) {
                    return Center(child: CircularProgressIndicator());
                  },
                );
                await saveImageInfirestore(profile.id, imagePaths, title, uuid);
                //setState(() { _isLoading = false });//hide loader
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurveyDataCollect(profileId: profile, final_address: address, uuid: uuid),
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
    final XFile? selected_image = 
          await _picker.pickImage(source: ImageSource.camera);
    if(selected_image!.path.isNotEmpty){
      _imageList.add(selected_image);

      //if (image == null) return;

      final location = await getApplicationDocumentsDirectory();
      final name = selected_image.path.split('/').last;
      final imageFile = File('${location.path}/$name');
      final newImage = await File(selected_image.path).copy(imageFile.path);
      imagePaths.add(imageFile);
    } 
    //print(selected_image!.path.toString());
    setState((){});
  }
}