import 'package:flutter/material.dart';
import 'package:clientta/features/app.dart';
import 'package:clientta/features/auth/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MyApp();
        }

        return const MaterialApp(home: LoginScreen());
      },
    );
  }
}
