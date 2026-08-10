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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  AuthRepository get _authRepository => dependency<AuthRepository>();

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final result = await _authRepository.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );
    if (!mounted) return;

    switch (result) {
      case Ok():
        setState(() => _sent = true);
      case Error(:final error):
        context.showSnackBarError(_errorMessage(error));
    }

    if (mounted) setState(() => _loading = false);
  }

  void _backToLogin() {
    Navigator.of(context).pushReplacementNamed(AuthRouters.login.path);
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: forgotPasswordSuccessString,
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: HubColors.seed,
              ),
              DSSpacing.md.y,
              Text(
                forgotPasswordSuccessString,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: HubColors.inkMuted,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        DSSpacing.xl.y,
        HubPrimaryButton(
          label: forgotPasswordBackToLoginString,
          onPressed: _backToLogin,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HubTextFormField(
            controller: _emailController,
            label: emailString,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: _validateEmail,
          ),
          DSSpacing.xl.y,
          HubPrimaryButton(
            label: sendPasswordResetLinkString,
            isLoading: _loading,
            onPressed: _loading ? null : _sendResetLink,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HubAuthScaffold(
      title: forgotPasswordTitleString,
      subtitle: forgotPasswordSubtitleString,
      highlights: [
        HubAuthHighlight(
          icon: Icons.lock_reset_outlined,
          label: authHighlightSecureString,
        ),
      ],
      footer: Center(
        child: TextButton(
          onPressed: _loading ? null : _backToLogin,
          child: Text(forgotPasswordBackToLoginString),
        ),
      ),
      child: _sent ? _buildSuccessState() : _buildForm(),
    );
  }
}
