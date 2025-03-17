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
    apiKey: 'AIzaSyDccT23YPGwvGWs1kbumGpAuj4tWp4Nbuk',
    appId: '1:874248925376:web:ce48f06ceba9fe5eb2fd25',
    messagingSenderId: '874248925376',
    projectId: 'osprey-flutter',
    authDomain: 'osprey-flutter.firebaseapp.com',
    storageBucket: 'osprey-flutter.firebasestorage.app',
    measurementId: 'G-SFN2BN28XH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_okg65Br3Vh-6knip0BvlXbTOptnDGwc',
    appId: '1:874248925376:android:021d915055f41068b2fd25',
    messagingSenderId: '874248925376',
    projectId: 'osprey-flutter',
    storageBucket: 'osprey-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBK0Foh-Vn5v6QxjxAbAJvVtpncmhmInlI',
    appId: '1:874248925376:ios:fc5427f4e74f7b21b2fd25',
    messagingSenderId: '874248925376',
    projectId: 'osprey-flutter',
    storageBucket: 'osprey-flutter.firebasestorage.app',
    iosBundleId: 'com.example.ospreyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBK0Foh-Vn5v6QxjxAbAJvVtpncmhmInlI',
    appId: '1:874248925376:ios:fc5427f4e74f7b21b2fd25',
    messagingSenderId: '874248925376',
    projectId: 'osprey-flutter',
    storageBucket: 'osprey-flutter.firebasestorage.app',
    iosBundleId: 'com.example.ospreyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDccT23YPGwvGWs1kbumGpAuj4tWp4Nbuk',
    appId: '1:874248925376:web:3f2993a83c74d8b7b2fd25',
    messagingSenderId: '874248925376',
    projectId: 'osprey-flutter',
    authDomain: 'osprey-flutter.firebaseapp.com',
    storageBucket: 'osprey-flutter.firebasestorage.app',
    measurementId: 'G-XJNZ4QYFSM',
  );
}
