import 'package:flutter/material.dart';

/// Warm Gourmet tokens from the Stitch screens, with a cocoa dark mode
/// so the terracotta kitchen still feels like the same product at night.
class KitchenColors {
  static Color primary = const Color(0xFFA33900);
  static Color primaryContainer = const Color(0xFFCC4900);
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color primaryFixed = const Color(0xFFFFDBCE);
  static Color secondary = const Color(0xFF006E2D);
  static Color onSecondary = const Color(0xFFFFFFFF);
  static Color secondaryContainer = const Color(0xFF7CF994);
  static Color tertiary = const Color(0xFF825100);
  static Color tertiaryContainer = const Color(0xFFA36700);
  static Color surface = const Color(0xFFFFF8F5);
  static Color surfaceLowest = const Color(0xFFFFFFFF);
  static Color surfaceLow = const Color(0xFFFAF2EE);
  static Color surfaceContainer = const Color(0xFFF4ECE8);
  static Color surfaceHigh = const Color(0xFFEEE7E3);
  static Color surfaceHighest = const Color(0xFFE9E1DD);
  static Color onSurface = const Color(0xFF1E1B19);
  static Color onSurfaceVariant = const Color(0xFF5A4138);
  static Color outline = const Color(0xFF8E7166);
  static Color outlineVariant = const Color(0xFFE2BFB2);
  static Color error = const Color(0xFFBA1A1A);
  static Color errorContainer = const Color(0xFFFFDAD6);
  static Color onErrorContainer = const Color(0xFF93000A);
  static Color inverseSurface = const Color(0xFF33302D);
  static Color inverseOnSurface = const Color(0xFFF7EFEB);
  static bool isDark = false;

  static void apply(bool dark) {
    isDark = dark;
    if (!dark) {
      primary = const Color(0xFFA33900);
      primaryContainer = const Color(0xFFCC4900);
      onPrimary = const Color(0xFFFFFFFF);
      primaryFixed = const Color(0xFFFFDBCE);
      secondary = const Color(0xFF006E2D);
      secondaryContainer = const Color(0xFF7CF994);
      tertiary = const Color(0xFF825100);
      surface = const Color(0xFFFFF8F5);
      surfaceLowest = const Color(0xFFFFFFFF);
      surfaceLow = const Color(0xFFFAF2EE);
      surfaceContainer = const Color(0xFFF4ECE8);
      surfaceHigh = const Color(0xFFEEE7E3);
      surfaceHighest = const Color(0xFFE9E1DD);
      onSurface = const Color(0xFF1E1B19);
      onSurfaceVariant = const Color(0xFF5A4138);
      outlineVariant = const Color(0xFFE2BFB2);
      errorContainer = const Color(0xFFFFDAD6);
      inverseSurface = const Color(0xFF33302D);
      inverseOnSurface = const Color(0xFFF7EFEB);
      return;
    }
    primary = const Color(0xFFFFB599);
    primaryContainer = const Color(0xFFCC4900);
    onPrimary = const Color(0xFF370E00);
    primaryFixed = const Color(0xFF5A2414);
    secondary = const Color(0xFF7CF994);
    secondaryContainer = const Color(0xFF0E3D22);
    tertiary = const Color(0xFFFFB95F);
    surface = const Color(0xFF1A1412);
    surfaceLowest = const Color(0xFF241C19);
    surfaceLow = const Color(0xFF2C221E);
    surfaceContainer = const Color(0xFF342824);
    surfaceHigh = const Color(0xFF3E312C);
    surfaceHighest = const Color(0xFF4A3B35);
    onSurface = const Color(0xFFF7EFEB);
    onSurfaceVariant = const Color(0xFFE2BFB2);
    outlineVariant = const Color(0xFF5A4138);
    errorContainer = const Color(0xFF5C1A16);
    inverseSurface = const Color(0xFFF7EFEB);
    inverseOnSurface = const Color(0xFF1E1B19);
  }

  static ThemeData material(TextTheme textTheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: surface,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onPrimary,
        surface: surface,
        onSurface: onSurface,
      ),
      textTheme: textTheme.apply(bodyColor: onSurface, displayColor: onSurface),
      fontFamily: textTheme.bodyMedium?.fontFamily,
    );
  }
}

/// Soft entrance used across portal cards, matching the Stitch hover/scale feel.
class RiseIn extends StatelessWidget {
  const RiseIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, (1 - value) * 16), child: child),
        );
      },
      child: child,
    );
  }
}
