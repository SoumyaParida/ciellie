import 'dart:convert';

import 'package:Ciellie/models/profile.dart';

//import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ciellie/network/prefs/profile_share_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static late SharedPreferences _preferences;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const _keyUser = 'user';

  static UserProfile myUser = UserProfile(
    image:
        "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
    name: '',
    email: '',
    phone: '',
    id: '',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserProfile user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static UserProfile getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : UserProfile.fromJson(jsonDecode(json));
  }
}