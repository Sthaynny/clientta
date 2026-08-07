import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return null;
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final result = await _authRepository.signInWithEmail(
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
    return HubOutlinedButton(
      label: signInWithGoogleString,
      icon: Icons.g_mobiledata_rounded,
      onPressed: _loading ? null : _signInWithGoogle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HubAuthScaffold(
      title: loginWelcomeString,
      subtitle: loginSubtitleString,
      highlights: [
        HubAuthHighlight(
          icon: Icons.cloud_off_outlined,
          label: authHighlightOfflineString,
        ),
        HubAuthHighlight(
          icon: Icons.sync_outlined,
          label: authHighlightSyncString,
        ),
        HubAuthHighlight(
          icon: Icons.verified_user_outlined,
          label: authHighlightSecureString,
        ),
      ],
      footer: Center(
        child: TextButton(
          onPressed:
              _loading
                  ? null
                  : () => Navigator.of(context).pushReplacementNamed(
                    AuthRouters.register.path,
                  ),
          child: Text(createAccountString),
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
              autofillHints: const [AutofillHints.password],
              validator: _validatePassword,
            ),
            DSSpacing.xl.y,
            HubPrimaryButton(
              label: loginString,
              isLoading: _loading,
              onPressed: _loading ? null : _signIn,
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
            DSSpacing.lg.y,
            const HubLegalLinks(),
          ],
        ),
      ),
    );
  }
}
