import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

abstract final class HubTheme {
  static const double minTouchTarget = 48;

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: HubColors.seed,
      brightness: Brightness.light,
      surface: HubColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: HubColors.seed,
        onPrimary: Colors.white,
        secondary: HubColors.schedule,
        onSecondary: Colors.white,
        surface: HubColors.surface,
        onSurface: HubColors.ink,
        error: HubColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: HubColors.canvas,
      visualDensity: VisualDensity.standard,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: HubColors.seedDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white, size: 26),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 26),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: HubColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HubColors.seed,
        foregroundColor: Colors.white,
        elevation: 2,
        extendedSizeConstraints: const BoxConstraints(
          minHeight: minTouchTarget,
          minWidth: minTouchTarget,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.md.value),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: HubColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HubColors.surface,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: DSSpacing.md.value,
          vertical: DSSpacing.md.value,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          borderSide: const BorderSide(color: HubColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          borderSide: const BorderSide(color: HubColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          borderSide: const BorderSide(color: HubColors.seed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          borderSide: const BorderSide(color: HubColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          borderSide: const BorderSide(color: HubColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: HubColors.inkMuted),
        errorStyle: const TextStyle(color: HubColors.error, fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          backgroundColor: HubColors.seed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          foregroundColor: HubColors.seed,
        ),
      ),
      focusColor: HubColors.focusRing.withValues(alpha: 0.12),
      hoverColor: HubColors.seed.withValues(alpha: 0.06),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HubColors.seed;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: HubColors.inkMuted, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.md.value),
        ),
        titleTextStyle: const TextStyle(
          color: HubColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: HubColors.inkMuted,
          fontSize: 15,
          height: 1.45,
        ),
      ),
    );
  }
}
