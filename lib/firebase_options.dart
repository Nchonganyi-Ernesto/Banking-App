import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAjud796IifoVdD-DyO8sfUWRM19RL-ceY',
    appId: '1:502998556614:web:19e0a6d9fdaa0c44211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    authDomain: 'bankapp-2e30d.firebaseapp.com',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
    measurementId: 'G-PBHNCGY1W0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp5IQoGf4iZzkV8_0Fh6RrWlTBhS8qJsI',
    appId: '1:502998556614:android:b1667dee34d82298211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOxUIiq-RQ9SiADPD1WEQBm6fPFvgkU1c',
    appId: '1:502998556614:ios:4a3c16dafc9ee09d211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
    iosClientId: '502998556614-0di631cf6isscpf81ug088ersr86ejr7.apps.googleusercontent.com',
    iosBundleId: 'com.example.zentra',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOxUIiq-RQ9SiADPD1WEQBm6fPFvgkU1c',
    appId: '1:502998556614:ios:4a3c16dafc9ee09d211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
    iosClientId: '502998556614-0di631cf6isscpf81ug088ersr86ejr7.apps.googleusercontent.com',
    iosBundleId: 'com.example.zentra',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjud796IifoVdD-DyO8sfUWRM19RL-ceY',
    appId: '1:502998556614:web:dfbaed7df61cc581211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    authDomain: 'bankapp-2e30d.firebaseapp.com',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
    measurementId: 'G-240F1B6B9D',
  );
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAjud796IifoVdD-DyO8sfUWRM19RL-ceY',
    appId: '1:502998556614:web:dfbaed7df61cc581211cc7',
    messagingSenderId: '502998556614',
    projectId: 'bankapp-2e30d',
    authDomain: 'bankapp-2e30d.firebaseapp.com',
    storageBucket: 'bankapp-2e30d.firebasestorage.app',
    measurementId: 'G-240F1B6B9D',
  );
}
