import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

//import 'package:flutter_user_profile/user/user_data.dart';
//import 'package:flutter_user_profile/widgets/appbar_widget.dart';

import 'package:Ciellie/network/prefs/profile_share_prefs.dart';
import 'package:Ciellie/widgets/appbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/constants.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
class EditPhoneFormPage extends StatefulWidget {
  final String? email;
  final String? phone;
  const EditPhoneFormPage({Key? key, required this.email, required this.phone}) : super(key: key);
  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final phoneController = TextEditingController();
  var user = UserData.myUser;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void updateUserValue(String phone) {
    String formattedPhoneNumber = "(" +
        phone.substring(0, 3) +
        ") " +
        phone.substring(3, 6) +
        "-" +
        phone.substring(6, phone.length);
    user.phone = formattedPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 320,
                    child: const Text(
                      "What's Your Phone Number?",
                      style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(64, 105, 225, 1),
                    ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (isAlpha(value)) {
                              return 'Only Numbers Please';
                            } else if (value.length < 10) {
                              return 'Please enter a VALID phone number';
                            }
                            return null;
                          },
                          style: kBodyText.copyWith(
                            color: Colors.white,
                          ),
                          controller: phoneController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            hintText: "Phone Number",
                            hintStyle: kBodyText,
                          ),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        
                        child: SizedBox(
                          
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              onClickButton(context, phoneController.text);
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate() &&
                                  isNumeric(phoneController.text)) {
                                updateUserValue(phoneController.text);
                                Navigator.pop(context);
                              }
                              
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
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