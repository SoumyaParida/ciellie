import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Ciellie/models/exceptions/auth_exception.dart';
import 'package:Ciellie/models/result.dart';
import 'package:Ciellie/models/survey.dart';
import 'package:Ciellie/models/user.dart';
import 'package:Ciellie/models/profile.dart';
import 'package:Ciellie/network/prefs/shared_prefs.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';

class DbHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late SharedPrefs _sharedPrefs;

  DbHelper._();

  static final DbHelper instance = DbHelper._()
    ..init().then((_) => print("DbHelper initialized.."));

  Future<void> init() async {
    _sharedPrefs = await SharedPrefs.getInstance();
  }

  Future<List<Survey>> get surveysFuture async {
    final surveysSnapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .orderBy("createdAt", descending: true)
        .get();
    final surveys = surveysSnapshot.docs.map((e) async {
      //join user
      final creatorId = e['creatorId'];
      final creatorDocSnapshot =
          await _db.collection("users").doc(creatorId).get();
      final creator = User.fromDocSnapshot(creatorDocSnapshot);
      return Survey.fromDocSnapshot(e, creator);
    }).toList();
    return Future.wait(surveys);
  }

  Future<Result<User>> findUserByUsername(String username) async {
    final snapshot = await _db
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    try {
      final doc = snapshot.docs.single;
      return Success(User.fromDocSnapshot(doc));
    } on StateError catch (e) {
      print(e);
      return Error(AuthException.userNotFound);
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<Result<User>> findUserByEmail(String email) async {
    final snapshot =
        await _db.collection("users").where("email", isEqualTo: email).get();
    try {
      final doc = snapshot.docs.single;
      return Success(User.fromDocSnapshot(doc));
    } on StateError catch (e) {
      print(e);
      return Error(AuthException.userNotFound);
    } on Exception catch (e) {
      print(e);
      return Error(e);
    }
  }

  Future<void> createNewUser(User user) async {
    await _db
        .collection("users")
        .doc(user.id)
        .set({'username': user.username, 'email': user.email});
  }

  Future<User> getUserData() async {
    final ref = await _db
        .collection("users").get();
      final doc = ref.docs.single;
    return User.fromDocSnapshot(doc);
  }

  /*Future<List<UserProfile>> get ProfileFuture async {
    final profileSnapshot = await FirebaseFirestore.instance
        .collection("profiles")
        .get();
    final profiles = profileSnapshot.docs.map((e) async {
      //join user
      final creatorId = e['creatorId'];
      final creatorDocSnapshot =
          await _db.collection("users").doc(creatorId).get();
      final creator = User.fromDocSnapshot(creatorDocSnapshot);
      return UserProfile.fromDocSnapshot(e, creator);
    }).toList();
    return Future.wait(profiles);
  }*/

  Future<void> createProfile(UserProfile userData) async {
    await _db
        .collection("profiles")
        .doc(userData.id)
        .set({'id': userData.id, 'name': userData.name, 'email': userData.email, 'phone': userData.phone, 'image': userData.image});
  }
  
}