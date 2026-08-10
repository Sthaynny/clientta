import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/features/auth/view/forgot_password_screen.dart';
import 'package:clientta/features/auth/view/login_screen.dart';
import 'package:clientta/features/auth/view/register_screen.dart';

/// Public routes shown before authentication.
class AuthShell extends StatelessWidget {
  const AuthShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: HubTheme.light(),
      initialRoute: AuthRouters.login.path,
      routes: {
        AuthRouters.login.path: (context) => const LoginScreen(),
        AuthRouters.register.path: (context) => const RegisterScreen(),
        AuthRouters.forgotPassword.path: (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
