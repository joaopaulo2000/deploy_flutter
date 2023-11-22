import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
    apiKey: 'AIzaSyDHwLvDnkSw2vPjTO4De6Bgmt4wBtQ4MiM',
    appId: '1:7966748720:web:7b8b58d1aaf2977729fdf5',
    messagingSenderId: '7966748720',
    projectId: 'moca-geriuff',
    authDomain: 'moca-geriuff.firebaseapp.com',
    databaseURL: 'https://moca-geriuff-default-rtdb.firebaseio.com',
    storageBucket: 'moca-geriuff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwf7z8ZKg7BLZ-Pl_1_YYL2HhCWznzbuw',
    appId: '1:7966748720:android:c9ecf8645e86d30629fdf5',
    messagingSenderId: '7966748720',
    projectId: 'moca-geriuff',
    databaseURL: 'https://moca-geriuff-default-rtdb.firebaseio.com',
    storageBucket: 'moca-geriuff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6LdT2xd5VToR6BD-escMmiEdVCZ1dyr0',
    appId: '1:7966748720:ios:c866674c5c478ad829fdf5',
    messagingSenderId: '7966748720',
    projectId: 'moca-geriuff',
    databaseURL: 'https://moca-geriuff-default-rtdb.firebaseio.com',
    storageBucket: 'moca-geriuff.appspot.com',
    iosBundleId: 'com.example.projetoFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6LdT2xd5VToR6BD-escMmiEdVCZ1dyr0',
    appId: '1:7966748720:ios:6ea24af9a9f8bb2229fdf5',
    messagingSenderId: '7966748720',
    projectId: 'moca-geriuff',
    databaseURL: 'https://moca-geriuff-default-rtdb.firebaseio.com',
    storageBucket: 'moca-geriuff.appspot.com',
    iosBundleId: 'com.example.projetoFinal.RunnerTests',
  );
}
