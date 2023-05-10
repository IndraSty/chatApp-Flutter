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
    apiKey: 'AIzaSyCd4V7-BPWhdwTFMVmqh6YcnLxWeDVY2xs',
    appId: '1:791033995290:web:2a2d136d41064d4a47f1a3',
    messagingSenderId: '791033995290',
    projectId: 'chatapp-indra',
    authDomain: 'chatapp-indra.firebaseapp.com',
    storageBucket: 'chatapp-indra.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCg9nljq5Li8y8tUCAAXo4NMxiDXQP27l0',
    appId: '1:791033995290:android:c4f77e686ef2b16447f1a3',
    messagingSenderId: '791033995290',
    projectId: 'chatapp-indra',
    storageBucket: 'chatapp-indra.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYU1VUad4QDRTzTNZNYYO1vBG-TvuwIVA',
    appId: '1:791033995290:ios:8f9ed7832f260da647f1a3',
    messagingSenderId: '791033995290',
    projectId: 'chatapp-indra',
    storageBucket: 'chatapp-indra.appspot.com',
    iosClientId: '791033995290-sqlsfhqdh5onq65fo0ms1si84m9utsvc.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYU1VUad4QDRTzTNZNYYO1vBG-TvuwIVA',
    appId: '1:791033995290:ios:8f9ed7832f260da647f1a3',
    messagingSenderId: '791033995290',
    projectId: 'chatapp-indra',
    storageBucket: 'chatapp-indra.appspot.com',
    iosClientId: '791033995290-sqlsfhqdh5onq65fo0ms1si84m9utsvc.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapps',
  );
}