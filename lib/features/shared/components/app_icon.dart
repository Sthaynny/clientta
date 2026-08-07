import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Marca Clientta em superfícies claras (login) ou escuras (app bar, drawer).
class AppIcon extends StatelessWidget {
  const AppIcon.onLight({super.key, this.size = 60}) : _path = _onLightPath;

  const AppIcon.onDark({super.key, this.size = 60}) : _path = _onDarkPath;

  /// Alias legado — preferir [AppIcon.onDark].
  const AppIcon.hub({super.key, this.size = 60}) : _path = _onDarkPath;

  static const _onLightPath = 'assets/images/app-icon-on-light.png';
  static const _onDarkPath = 'assets/images/app-icon-mark.png';

  /// Lado do ícone em pixels lógicos (não confundir com [Image.asset] `scale`).
  final double size;
  final String _path;

  @override
  Widget build(BuildContext context) {
    return DSAnimatedSize(
      child: Image.asset(
        _path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
