import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetSurveyName extends StatelessWidget {
  final String documentId;
  final String profileId;
  final String parameter;

  GetSurveyName({required this.documentId, required this.profileId, required this.parameter});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    CollectionReference surveys = FirebaseFirestore.instance.collection("surveys").doc(profileId).collection("survey");

    return FutureBuilder<DocumentSnapshot>(
      future: surveys.doc(documentId).get(),
      builder: ((context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = 
                    snapshot.data!.data() as Map<String, dynamic>;
        return Text("${data[parameter]}");
      }
      return Text("loading");
  }),
  );
  }
}