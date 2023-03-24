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
        actions: <Widget>[
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
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imageFromGallery(),
            null == imageFromPreferences ? Container() : imageFromPreferences!,
          ],
        ),
      ),
    );
  }
}
