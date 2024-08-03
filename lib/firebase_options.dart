// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAAhWGYzk24NRHsXRryQAIi3CBF-d7bvZ4',
    appId: '1:562674107058:web:8dfea4ec43bd76a41a3fab',
    messagingSenderId: '562674107058',
    projectId: 'fitquest-b82cc',
    authDomain: 'fitquest-b82cc.firebaseapp.com',
    databaseURL: 'https://fitquest-b82cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fitquest-b82cc.appspot.com',
    measurementId: 'G-L01ZYBQFB1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCja-qr06bmfXgXtb1nhNInsdF-GuuoKac',
    appId: '1:562674107058:android:b21e9bfba9dfcf951a3fab',
    messagingSenderId: '562674107058',
    projectId: 'fitquest-b82cc',
    databaseURL: 'https://fitquest-b82cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fitquest-b82cc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCO0u1RRoQsGXQNPju10e-_M3pD5AkompE',
    appId: '1:562674107058:ios:27494e4d3e22f91a1a3fab',
    messagingSenderId: '562674107058',
    projectId: 'fitquest-b82cc',
    databaseURL: 'https://fitquest-b82cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fitquest-b82cc.appspot.com',
    iosBundleId: 'com.example.caloriesTracking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCO0u1RRoQsGXQNPju10e-_M3pD5AkompE',
    appId: '1:562674107058:ios:27494e4d3e22f91a1a3fab',
    messagingSenderId: '562674107058',
    projectId: 'fitquest-b82cc',
    databaseURL: 'https://fitquest-b82cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fitquest-b82cc.appspot.com',
    iosBundleId: 'com.example.caloriesTracking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAAhWGYzk24NRHsXRryQAIi3CBF-d7bvZ4',
    appId: '1:562674107058:web:e0ea52cc23daf93f1a3fab',
    messagingSenderId: '562674107058',
    projectId: 'fitquest-b82cc',
    authDomain: 'fitquest-b82cc.firebaseapp.com',
    databaseURL: 'https://fitquest-b82cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fitquest-b82cc.appspot.com',
    measurementId: 'G-X8ML5EBZT5',
  );
}
