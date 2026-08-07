import 'package:firebase_core/firebase_core.dart';

import 'package:clientta/firebase_options.dart';

/// Inicialização do Firebase (Auth, Firestore, Functions).
Future<void> bootstrapFirebase() async {
  if (Firebase.apps.isNotEmpty) return;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
