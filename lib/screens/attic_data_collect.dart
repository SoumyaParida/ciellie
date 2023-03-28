import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'Utility.dart';
import 'package:Ciellie/util/Utility.dart';

class AppDataCollect extends StatefulWidget {
  const AppDataCollect({Key? key}) : super(key: key);

  @override
  State<AppDataCollect> createState() => _AppDataCollectState();
}

class _AppDataCollectState extends State<AppDataCollect> {
  Future<File>? imageFile;
  Image? imageFromPreferences;
  bool _load = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageList = [];

  pickImageFromGallery(ImageSource source) {
    setState(() {
      //imageFile = ImagePicker.pickImage(source: source) as Future<File>;
      imageFile = ImagePicker.platform.pickImage(source: source) as Future<File>;
      _load = false;
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
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
              OutlinedButton(
                onPressed: (){
                  selectImage();
                },
                child: const Text("Select Image")),
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
            ],
      )
      )
    );
  }

  Future<void> selectImage() async {
    final XFile? selected_image = 
          await _picker.pickImage(source: ImageSource.gallery);
    if(selected_image!.path.isNotEmpty){
      _imageList.add(selected_image);
    } 
    //print(selected_image!.path.toString());
    setState((){});
  }
}
