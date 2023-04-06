import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';

import 'package:Ciellie/models/result.dart';
import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/network/auth/authenticator.dart';
//import 'package:Ciellie/screens/survey/list/survey_list_screen.dart';
import 'package:Ciellie/util/context_utils.dart';
import 'package:Ciellie/widgets/progress_button.dart';
import 'package:Ciellie/util/alert_utils.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authenticator = Authenticator.instance;

  final usernameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                  "Login",
                  style: kHeadline,
                ),
                SizedBox(
                            height: 50,
                          ),
            TextFormField(
               style: kBodyText.copyWith(
                    color: Colors.white,
                  ),
              controller: usernameOrEmailController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "EMAIL ADDRESS",
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
            SizedBox(height: 20),
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ForgotPasswordPage(),
                              ),
                            );
                          },
                        child: Text(
                          "Forgot Password ?",
                          style: kBodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        ),
                      ],
                    ),
            SizedBox(height: 20),
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont't have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                        child: Text(
                          "Register",
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
                    "Login",
                    style: kButtonText.copyWith(color: Colors.black87),
                  ),
                ),
                ),
            SizedBox(height: context.height(.05)),
          ],
        ),
      ),
    );
  }

  Future onClickButton(BuildContext context) async {
    showDialog(
      context: context, 
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    final result = await authenticator.login(
        usernameOrEmailController.text.trim(), passwordController.text);
    if (result is Success<User>) {
      final loggedInUser = result.data;
      onLogin(context, loggedInUser);
    } else {
      context.alertError(result);
    }

    //Navigator.of(context).pop();
    //await Future.delayed(const Duration(seconds: 1), () {});
  }

  void onLogin(BuildContext context, User user) {
    print(user);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  MyHomePage(currentuser: user)));
  }

}

