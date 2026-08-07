import 'package:firebase_core/firebase_core.dart';

/// Inicialização do Firebase.
///
/// TODO: adicionar `firebase_options.dart` via FlutterFire CLI e passar
/// `options: DefaultFirebaseOptions.currentPlatform` em [Firebase.initializeApp].
Future<void> bootstrapFirebase() async {
  if (Firebase.apps.isNotEmpty) return;
  await Firebase.initializeApp();
}
