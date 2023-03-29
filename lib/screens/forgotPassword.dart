import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';
import '../constants.dart';

import 'package:Ciellie/models/result.dart';
import 'package:Ciellie/models/user.dart';

import 'package:Ciellie/network/auth/authenticator.dart';
//import 'package:Ciellie/screens/survey/list/survey_list_screen.dart';
import 'package:Ciellie/util/context_utils.dart';
import 'package:Ciellie/validate/validator.dart';
import 'package:Ciellie/widgets/progress_button.dart';
import 'package:Ciellie/util/alert_utils.dart';

//import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  
  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: AssetImage('assets/images/back_arrow.png'),
          ),
        ),
      ),
      body: SafeArea(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
            child: Column(
                  children: [
                    Flexible(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                            "Forgot Password ?",
                            style: kHeadline,
                          ),
                Text(
                  "\nReceive an email to reset your password.",
                  style: kBodyText2,
                ),
                SizedBox(
                            height: 50,
                          ),
                
                  
                TextFormField(
                  style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
                  validator: Validator.validateEmail,
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "E-Mail Address",
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
                child:TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black12,
                    ),
                  ),
                  onPressed: () => verifyEmail(),
                  child: Text(
                    "Reset Password",
                    style: kButtonText.copyWith(color: Colors.black87),
                  ),
                ),
                ),
                SizedBox(height: context.height(0.05)),
              ],
            ),
          ),
                    ),
                  ],
            ),
        ),
      ),
      ],
    );
  }

  Future verifyEmail() async{
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  try {
    await FirebaseAuth.instance
      .sendPasswordResetEmail(email: emailController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Reset Email Sent")));
    Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
      Navigator.of(context).pop();
    }
  }
}
