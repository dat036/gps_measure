import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Builds the Material 3 theme from design tokens (`design.md` §1, §3).
abstract final class LmTheme {
  static ThemeData get light => _build(LmColors.light, Brightness.light);
  static ThemeData get dark => _build(LmColors.dark, Brightness.dark);

  static ThemeData _build(LmColors c, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.brandPrimary,
          brightness: brightness,
        ).copyWith(
          primary: c.brandPrimary,
          onPrimary: c.onMode,
          error: c.dangerMain,
          onError: c.onMode,
          surface: c.surfaceCard,
          onSurface: c.textPrimary,
          onSurfaceVariant: c.textSecondary,
          outline: c.outlineDashed,
          outlineVariant: c.divider,
          scrim: c.scrim,
        );

    final textTheme = TextTheme(
      displaySmall: LmTypography.displayResult,
      headlineSmall: LmTypography.displayHero,
      titleLarge: LmTypography.titleScreen,
      titleMedium: LmTypography.titleSection,
      titleSmall: LmTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: LmTypography.bodyLg,
      bodyMedium: LmTypography.bodyMd,
      bodySmall: LmTypography.caption,
      labelLarge: LmTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
      labelMedium: LmTypography.labelCaps,
      labelSmall: LmTypography.caption,
    ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: LmTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.surfacePage,
      dividerColor: c.divider,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.surfaceCard,
        foregroundColor: c.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        titleTextStyle: LmTypography.titleScreen.copyWith(
          color: c.textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: c.surfaceCard,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.areaContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? c.brandPrimary
                : c.textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => LmTypography.caption.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? c.brandPrimary
                : c.textSecondary,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: LmRadius.lgAll),
        titleTextStyle: LmTypography.titleScreen.copyWith(
          color: c.textPrimary,
        ),
        contentTextStyle: LmTypography.bodyMd.copyWith(
          color: c.textSecondary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceSheet,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.divider,
        dragHandleSize: const Size(36, 4),
        shape: const RoundedRectangleBorder(borderRadius: LmRadius.sheetTop),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: LmRadius.smAll),
        backgroundColor: c.textPrimary,
        contentTextStyle: LmTypography.bodyMd.copyWith(color: c.surfaceCard),
        actionTextColor: c.brandPrimary,
      ),
      cardTheme: CardThemeData(
        color: c.surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: LmRadius.mdAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: LmRadius.smAll,
          borderSide: BorderSide(color: c.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: LmRadius.smAll,
          borderSide: BorderSide(color: c.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LmRadius.smAll,
          borderSide: BorderSide(color: c.brandPrimary, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brandPrimary,
          textStyle: LmTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(48, 48),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.brandPrimary,
          foregroundColor: c.onMode,
          textStyle: LmTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: LmRadius.mdAll),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          side: BorderSide(color: c.divider),
          textStyle: LmTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: LmRadius.mdAll),
        ),
      ),
    );
  }
}
