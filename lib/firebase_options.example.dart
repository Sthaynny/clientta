// Copie este arquivo para `lib/firebase_options.dart` após configurar o Firebase:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// O arquivo real não deve ser versionado (está no .gitignore).
// Para laboratório sem nuvem, consulte docs/GUIA_UNIVERSITARIO.md (alternativas).

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUBSTITUA_PELA_SUA_API_KEY',
    appId: 'SUBSTITUA_PELO_SEU_APP_ID',
    messagingSenderId: 'SUBSTITUA_PELO_SEU_SENDER_ID',
    projectId: 'SUBSTITUA_PELO_SEU_PROJECT_ID',
    authDomain: 'SUBSTITUA.firebaseapp.com',
    storageBucket: 'SUBSTITUA.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'SUBSTITUA_PELA_SUA_API_KEY',
    appId: 'SUBSTITUA_PELO_SEU_APP_ID',
    messagingSenderId: 'SUBSTITUA_PELO_SEU_SENDER_ID',
    projectId: 'SUBSTITUA_PELO_SEU_PROJECT_ID',
    storageBucket: 'SUBSTITUA.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'SUBSTITUA_PELA_SUA_API_KEY',
    appId: 'SUBSTITUA_PELO_SEU_APP_ID',
    messagingSenderId: 'SUBSTITUA_PELO_SEU_SENDER_ID',
    projectId: 'SUBSTITUA_PELO_SEU_PROJECT_ID',
    storageBucket: 'SUBSTITUA.appspot.com',
    iosBundleId: 'com.example.ufersa_hub',
  );
}
