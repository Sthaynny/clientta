import 'package:flutter/material.dart';

/// Paleta Clientta — ver [DESIGN.md].
abstract final class HubColors {
  static const Color seed = Color(0xFF1B6B5C);
  static const Color seedDark = Color(0xFF0F4A3F);
  static const Color onPrimaryMuted = Color(0xFFB8D4CB);
  static const Color canvas = Color(0xFFF4F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1A1F24);
  /// Texto secundário — ≥4.5:1 em `surface` e `canvas` (WCAG AA corpo).
  static const Color inkMuted = Color(0xFF475467);
  /// Contorno de componentes — ≥3:1 em `surface` (WCAG UI).
  static const Color border = Color(0xFF8A939C);
  /// Contorno decorativo leve (não usar para texto).
  static const Color borderSubtle = Color(0xFFE2E6EA);
  static const Color schedule = Color(0xFF2D6A8F);
  static const Color scheduleMuted = Color(0xFFE8F1F6);
  static const Color success = Color(0xFF2E7D52);
  static const Color successTint = Color(0xFFE6F4EE);
  static const Color warning = Color(0xFFC47A2A);
  static const Color warningTint = Color(0xFFFFF4E8);
  static const Color error = Color(0xFFC62828);
  static const Color errorTint = Color(0xFFFCE8E8);
  static const Color focusRing = Color(0xFF1B6B5C);
}
