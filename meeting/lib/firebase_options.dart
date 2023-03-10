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
    apiKey: 'AIzaSyD9-LluoDiITrGeTwYRtsktgbYUL0H2RAo',
    appId: '1:904903215267:web:4b2d7b0d5ab2c2fa565716',
    messagingSenderId: '904903215267',
    projectId: 'meeting-ba59d',
    authDomain: 'meeting-ba59d.firebaseapp.com',
    storageBucket: 'meeting-ba59d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnJjfBXh88UsWjQ6_LutVGqFIc7Vpe0-o',
    appId: '1:904903215267:android:13fd29573e87eb38565716',
    messagingSenderId: '904903215267',
    projectId: 'meeting-ba59d',
    storageBucket: 'meeting-ba59d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASw5GT3yO_O6UNA4XIr44qH61rHxepFbI',
    appId: '1:904903215267:ios:9b70f7529ab6a65c565716',
    messagingSenderId: '904903215267',
    projectId: 'meeting-ba59d',
    storageBucket: 'meeting-ba59d.appspot.com',
    iosClientId: '904903215267-qhj10r859d0j8ufdvjn1713bn6mg1u2h.apps.googleusercontent.com',
    iosBundleId: 'com.example.meeting',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASw5GT3yO_O6UNA4XIr44qH61rHxepFbI',
    appId: '1:904903215267:ios:9b70f7529ab6a65c565716',
    messagingSenderId: '904903215267',
    projectId: 'meeting-ba59d',
    storageBucket: 'meeting-ba59d.appspot.com',
    iosClientId: '904903215267-qhj10r859d0j8ufdvjn1713bn6mg1u2h.apps.googleusercontent.com',
    iosBundleId: 'com.example.meeting',
  );
}
