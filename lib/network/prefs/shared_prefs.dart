import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedPrefs {
  SharedPreferences? _prefs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  SharedPrefs._();

  Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<SharedPrefs> getInstance() async {
    final instance = SharedPrefs._();
    await instance.init();
    return instance;
  }

  User? getUser() {
    final loggerInUserJsonStr = _prefs!.getString("logged_in_user");
    if (loggerInUserJsonStr == null) return null;
    final loggedInUserJson = json.decode(loggerInUserJsonStr);
    print(loggedInUserJson);
    return User.fromJson(loggedInUserJson);
  }

  /*UserProfile? getUserData() {
    final loggerInUserJsonStr = _prefs!.getString("logged_in_user");
    if (loggerInUserJsonStr == null) return null;
    final loggedInUserJson = json.decode(loggerInUserJsonStr);
    print(loggedInUserJson);
    return UserProfile.fromJson(loggedInUserJson);
  }*/

  Future<void> putUser(User user) async {
    final loggedInUserJson = json.encode(user.toJson());
    await _prefs!.setString("logged_in_user", loggedInUserJson);
  }

  Future<void> removeUser() async {
    await _prefs!.remove("logged_in_user");
  }

  Future<UserProfile> getUserProfileDetails(String email)async{
    final snapshot =
        await _db.collection("profiles").where("email", isEqualTo: email).get();
    final profile = snapshot.docs.map((e) => UserProfile.fromDocSnapshot(e)).single;
    return profile;
  }
}
