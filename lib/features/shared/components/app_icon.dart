import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  AppIcon({super.key, this.size = 60}) {
    _path = 'assets/images/app-icon.png';
  }

  AppIcon.hub({super.key, this.size = 60}) {
    _path = 'assets/images/app-icon-mark.png';
  }

  /// Lado do ícone em pixels lógicos (não confundir com [Image.asset] `scale`).
  final double size;
  late final String _path;

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
