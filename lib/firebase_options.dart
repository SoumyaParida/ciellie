// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAp7M-k4kgSUAfzEZj2p14tnaec2pONbU4',
    appId: '1:854485873054:web:393b68e7a9d4c2131d268f',
    messagingSenderId: '854485873054',
    projectId: 'ciellie',
    authDomain: 'ciellie.firebaseapp.com',
    databaseURL: 'https://ciellie-default-rtdb.firebaseio.com',
    storageBucket: 'ciellie.appspot.com',
    measurementId: 'G-0JWBL8YGL1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUprd8Ae-eF9JuiQoHP6eZIbdJY0Z8ilM',
    appId: '1:854485873054:android:ff4fbcea4a53508e1d268f',
    messagingSenderId: '854485873054',
    projectId: 'ciellie',
    databaseURL: 'https://ciellie-default-rtdb.firebaseio.com',
    storageBucket: 'ciellie.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMe6jnGIXpO5GQ1C3s50p62bXea87LHHc',
    appId: '1:854485873054:ios:b37bb8bcb4c245ed1d268f',
    messagingSenderId: '854485873054',
    projectId: 'ciellie',
    databaseURL: 'https://ciellie-default-rtdb.firebaseio.com',
    storageBucket: 'ciellie.appspot.com',
    iosClientId: '854485873054-s43hgur59m5lrmjdroi42eaoi7gui5oj.apps.googleusercontent.com',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMe6jnGIXpO5GQ1C3s50p62bXea87LHHc',
    appId: '1:854485873054:ios:b37bb8bcb4c245ed1d268f',
    messagingSenderId: '854485873054',
    projectId: 'ciellie',
    databaseURL: 'https://ciellie-default-rtdb.firebaseio.com',
    storageBucket: 'ciellie.appspot.com',
    iosClientId: '854485873054-s43hgur59m5lrmjdroi42eaoi7gui5oj.apps.googleusercontent.com',
    iosBundleId: 'com.example.login',
  );
}