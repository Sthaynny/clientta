import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/shared/hub/hub_primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException {
      if (!mounted) return;
      context.showSnackBarError(credenciaisInvalidasString);
    } catch (_) {
      if (!mounted) return;
      context.showSnackBarError(errorDefaultString);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(DSSpacing.lg.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DSSpacing.xl.y,
              Text(
                loginWelcomeString,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: HubColors.ink,
                ),
              ),
              DSSpacing.sm.y,
              DSBodyText(
                loginSubtitleString,
                color: HubColors.inkMuted,
              ),
              DSSpacing.xl.y,
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: emailString),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              DSSpacing.md.y,
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: passwordString),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
              ),
              DSSpacing.xl.y,
              HubPrimaryButton(
                label: loginString,
                isLoading: _loading,
                onPressed: _signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
