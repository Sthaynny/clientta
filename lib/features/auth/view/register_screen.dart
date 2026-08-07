import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  AuthRepository get _authRepository => dependency<AuthRepository>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _errorMessage(Exception error) {
    final text = error.toString();
    const prefix = 'Exception: ';
    if (text.startsWith(prefix)) {
      return text.substring(prefix.length);
    }
    return text;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return errorEmailRequiredString;
    if (!email.contains('@')) return errorEmailInvalidString;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return errorPasswordRequiredString;
    if (value.length < 6) return errorWeakPasswordString;
    return null;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final result = await _authRepository.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;

    switch (result) {
      case Ok():
        break;
      case Error(:final error):
        context.showSnackBarError(_errorMessage(error));
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    final result = await _authRepository.signInWithGoogle();
    if (!mounted) return;

    switch (result) {
      case Ok():
        break;
      case Error(:final error):
        context.showSnackBarError(_errorMessage(error));
    }

    if (mounted) setState(() => _loading = false);
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _loading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(HubTheme.minTouchTarget),
          foregroundColor: HubColors.ink,
          side: const BorderSide(color: HubColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          ),
        ),
        child: Text(signInWithGoogleString),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HubAuthScaffold(
      title: registerWelcomeString,
      subtitle: registerSubtitleString,
      footer: Center(
        child: TextButton(
          onPressed:
              _loading
                  ? null
                  : () => Navigator.of(context).pushReplacementNamed(
                    AuthRouters.login.path,
                  ),
          child: Text(alreadyHaveAccountString),
        ),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HubTextFormField(
              controller: _emailController,
              label: emailString,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: _validateEmail,
            ),
            DSSpacing.md.y,
            HubTextFormField(
              controller: _passwordController,
              label: passwordString,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validatePassword,
            ),
            DSSpacing.xl.y,
            HubPrimaryButton(
              label: registerString,
              isLoading: _loading,
              onPressed: _loading ? null : _signUp,
            ),
            DSSpacing.lg.y,
            Row(
              children: [
                const Expanded(child: Divider(color: HubColors.border)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DSSpacing.md.value),
                  child: Text(
                    authDividerOrString,
                    style: const TextStyle(color: HubColors.inkMuted),
                  ),
                ),
                const Expanded(child: Divider(color: HubColors.border)),
              ],
            ),
            DSSpacing.lg.y,
            _buildGoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
