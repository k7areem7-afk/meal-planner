import 'package:flutter/material.dart';

/// Green, orange and yellow — fresh produce colors.
class Brand {
  static const green = Color(0xFF5E9E2F);
  static const greenLight = Color(0xFF8BC34A);
  static const greenDark = Color(0xFF243B16);
  static const orange = Color(0xFFF57C00);
  static const yellow = Color(0xFFFFB300);
  static const cream = Color(0xFFFBF8F0);

  static const headerGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xFF6DAA35), Color(0xFF9CC94A), Color(0xFFFFC94A)],
  );

  static const warmGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xFFFFB300), Color(0xFFF57C00)],
  );
}

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final cs = ColorScheme.fromSeed(
    seedColor: Brand.green,
    brightness: b,
    primary: dark ? Brand.greenLight : Brand.green,
    secondary: Brand.orange,
    tertiary: Brand.yellow,
    surface: dark ? const Color(0xFF15190F) : Brand.cream,
  );
  final radius = BorderRadius.circular(20);
  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface),
    ),
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: dark ? const Color(0xFF20261A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 52),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: const Size(64, 48),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF20261A) : Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: cs.outlineVariant)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: cs.outlineVariant)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: cs.outlineVariant),
      selectedColor: Brand.greenDark,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: cs.onSurface),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Brand.yellow.withValues(alpha: 0.35),
      labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
  );
}
