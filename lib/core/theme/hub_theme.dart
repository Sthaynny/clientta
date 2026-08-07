import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

abstract final class HubTheme {
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
        surface: HubColors.surface,
        onSurface: HubColors.ink,
      ),
      scaffoldBackgroundColor: HubColors.canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: HubColors.seedDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white, size: 26),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 26),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: HubColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HubColors.seed,
        foregroundColor: Colors.white,
        elevation: 2,
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
          borderSide: const BorderSide(color: HubColors.seed, width: 1.5),
        ),
        labelStyle: const TextStyle(color: HubColors.inkMuted),
      ),
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
    );
  }
}
