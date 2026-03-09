// GENERATED-LIKE PLACEHOLDER
//
// This file is intentionally a skeleton so the project can compile before you
// connect Firebase.
//
// ✅ Recommended setup:
// 1) Install FlutterFire CLI
// 2) Run: `flutterfire configure`
// 3) Replace this file with the generated one.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
        return linux;
      case TargetPlatform.fuchsia:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCx-OQCrgYywenDOWGh4JQ469vW86eW_Ao',
    appId: '1:30619345639:web:91eeea5d6f78c579e9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    authDomain: 'my-club-cc4e2.firebaseapp.com',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
    measurementId: 'G-MT2QGVFC2R',
  );

  // Replace these placeholder values after running `flutterfire configure`.

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMhFDEWJjHZ-Zx8t42WjnBhIlQ_rQagMU',
    appId: '1:30619345639:android:22460a5786dccbebe9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqAIOZmh8h5Ankm7pyqiCd0iLbyRP4tYw',
    appId: '1:30619345639:ios:cfcb8052b45ef289e9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
    iosBundleId: 'com.example.myClub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqAIOZmh8h5Ankm7pyqiCd0iLbyRP4tYw',
    appId: '1:30619345639:ios:cfcb8052b45ef289e9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
    iosBundleId: 'com.example.myClub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCx-OQCrgYywenDOWGh4JQ469vW86eW_Ao',
    appId: '1:30619345639:web:243dce8fd5538ca4e9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    authDomain: 'my-club-cc4e2.firebaseapp.com',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
    measurementId: 'G-0MR3F06CXC',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCx-OQCrgYywenDOWGh4JQ469vW86eW_Ao',
    appId: '1:30619345639:web:243dce8fd5538ca4e9b842',
    messagingSenderId: '30619345639',
    projectId: 'my-club-cc4e2',
    authDomain: 'my-club-cc4e2.firebaseapp.com',
    storageBucket: 'my-club-cc4e2.firebasestorage.app',
    measurementId: 'G-0MR3F06CXC',
  );
}
