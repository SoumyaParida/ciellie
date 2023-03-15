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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  final formKey = GlobalKey<FormState>();

  //static const routeName = "/auth/signup";

  final authenticator = Authenticator.instance;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  
  navigateToSignInScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SignInPage()));
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
                            "Register",
                            style: kHeadline,
                          ),
                Text(
                  "\nCreate new account to get started.",
                  style: kBodyText2,
                ),
                SizedBox(
                            height: 50,
                          ),
                TextFormField(
                  style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
                  maxLength: Validator.MAX_USERNAME_LENGTH,
                  validator: Validator.validateUsername,
                  controller: usernameController,
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "USER NAME",
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
                  
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                TextFormField(
                  style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
                  validator: Validator.validatePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),                 
                    hintText: "Password",
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
                SizedBox(height: 16),
                TextFormField(
                  style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
                  validator: (value) => Validator.validatePasswordRepeat(
                      passwordController.text, value),
                  controller: passwordRepeatController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Repeat Password",
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
                SizedBox(height: 20),
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          },
                        child: Text(
                          "Sign In",
                          style: kBodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        ),
                      ],
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
                  onPressed: () => onClickButton(context),
                  child: Text(
                    "Register",
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

  Future<void> onClickButton(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await createAccount(context);
    }
  }

  Future<void> createAccount(BuildContext context) async {
    final result = await authenticator.signup(usernameController.text.trim(),
        emailController.text.trim(), passwordController.text);
    if (result is Success<User>) {
      final loggedInUser = result.data;
      onSignup(context, loggedInUser);
    } else {
      context.alertError(result);
    }
  }

  void onSignup(BuildContext context, User user) {
    print(user);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MyHomePage()));
  }
}
