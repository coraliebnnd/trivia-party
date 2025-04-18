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
    apiKey: 'AIzaSyCfJbjZ4q9IHcS3LQBy6dVFYLsJoT1dPMo',
    appId: '1:326750254794:web:794f56e58b649889f5e633',
    messagingSenderId: '326750254794',
    projectId: 'trivia-party-522a9',
    authDomain: 'trivia-party-522a9.firebaseapp.com',
    databaseURL: 'https://trivia-party-522a9-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'trivia-party-522a9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsgZKXsovl4zRhov037uMnFWHcc29UHyc',
    appId: '1:326750254794:android:3d17ae332aa01439f5e633',
    messagingSenderId: '326750254794',
    projectId: 'trivia-party-522a9',
    databaseURL: 'https://trivia-party-522a9-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'trivia-party-522a9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXIfjhk9ampGbKZyXH2QHMuGZMPxSYG-g',
    appId: '1:326750254794:ios:6b4aea07bc75e7dff5e633',
    messagingSenderId: '326750254794',
    projectId: 'trivia-party-522a9',
    databaseURL: 'https://trivia-party-522a9-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'trivia-party-522a9.firebasestorage.app',
    iosBundleId: 'de.mad.triviaParty',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXIfjhk9ampGbKZyXH2QHMuGZMPxSYG-g',
    appId: '1:326750254794:ios:6b4aea07bc75e7dff5e633',
    messagingSenderId: '326750254794',
    projectId: 'trivia-party-522a9',
    databaseURL: 'https://trivia-party-522a9-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'trivia-party-522a9.firebasestorage.app',
    iosBundleId: 'de.mad.triviaParty',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfJbjZ4q9IHcS3LQBy6dVFYLsJoT1dPMo',
    appId: '1:326750254794:web:daed2d69786337a9f5e633',
    messagingSenderId: '326750254794',
    projectId: 'trivia-party-522a9',
    authDomain: 'trivia-party-522a9.firebaseapp.com',
    databaseURL: 'https://trivia-party-522a9-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'trivia-party-522a9.firebasestorage.app',
  );
}
