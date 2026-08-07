import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/app.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';
import 'package:clientta/features/auth/view/auth_shell.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/shared/hub/hub_loading_skeletons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildChild(snapshot),
        );
      },
    );
  }

  Widget _buildChild(AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const _AuthLoadingShell(key: ValueKey('auth-loading'));
    }

    final user = snapshot.data;
    if (user != null) {
      return _AuthenticatedBootstrap(
        key: ValueKey('app-${user.uid}'),
        user: user,
      );
    }

    return const AuthShell(key: ValueKey('auth-shell'));
  }
}

class _AuthLoadingShell extends StatelessWidget {
  const _AuthLoadingShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: HubTheme.light(),
      home: Scaffold(
        body: Semantics(
          label: 'Carregando',
          child: const HubBootstrapLoadingSkeleton(),
        ),
      ),
    );
  }
}

class _AuthenticatedBootstrap extends StatefulWidget {
  const _AuthenticatedBootstrap({super.key, required this.user});

  final User user;

  @override
  State<_AuthenticatedBootstrap> createState() =>
      _AuthenticatedBootstrapState();
}

class _AuthenticatedBootstrapState extends State<_AuthenticatedBootstrap> {
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (mounted) {
      setState(() {
        _failed = false;
        _ready = false;
      });
    }

    final result = await dependency<UserRepository>().ensureUserProfile(
      uid: widget.user.uid,
      email: widget.user.email,
    );

    if (!mounted) return;

    switch (result) {
      case Ok():
        await dependency<BillingRepository>().syncEntitlements();
        if (!mounted) return;
        setState(() => _ready = true);
      case Error():
        setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return MaterialApp(
        theme: HubTheme.light(),
        home: Scaffold(
          body: Center(
            child: TextButton(
              onPressed: _bootstrap,
              child: Text(tenteNovamenteString),
            ),
          ),
        ),
      );
    }

    if (!_ready) {
      return const _AuthLoadingShell();
    }

    return const MyApp();
  }
}
