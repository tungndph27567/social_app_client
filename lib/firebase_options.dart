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
    apiKey: 'AIzaSyChwXKZLu9ZAWx_2ofvKOiZKYfXA6xQvZM',
    appId: '1:699308918107:web:738653fcb4ad729f32067e',
    messagingSenderId: '699308918107',
    projectId: 'fluttertutorial-e42ed',
    authDomain: 'fluttertutorial-e42ed.firebaseapp.com',
    storageBucket: 'fluttertutorial-e42ed.appspot.com',
    measurementId: 'G-LGRE7ZG5V3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbW0B9Z_NF36H0nXs7GeMmuUVRuvVYu_I',
    appId: '1:699308918107:android:34b63ad27e7dad0232067e',
    messagingSenderId: '699308918107',
    projectId: 'fluttertutorial-e42ed',
    storageBucket: 'fluttertutorial-e42ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAya_hSNTqv73Nj4Rx0mAjy0ubV71-CxhU',
    appId: '1:699308918107:ios:b19af0179df5789432067e',
    messagingSenderId: '699308918107',
    projectId: 'fluttertutorial-e42ed',
    storageBucket: 'fluttertutorial-e42ed.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAya_hSNTqv73Nj4Rx0mAjy0ubV71-CxhU',
    appId: '1:699308918107:ios:774ad2d79edb514032067e',
    messagingSenderId: '699308918107',
    projectId: 'fluttertutorial-e42ed',
    storageBucket: 'fluttertutorial-e42ed.appspot.com',
    iosBundleId: 'com.example.todoApp.RunnerTests',
  );
}
