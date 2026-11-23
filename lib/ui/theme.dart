import 'package:flutter/material.dart';

/// A color set the user can pick in Settings ← الألوان.
class Palette {
  final String id;
  final String name;
  final String emoji;
  final Color primary; // buttons, selection
  final Color primaryLight;
  final Color dark; // selected chips, strong text accents
  final Color secondary; // call-to-action (orange role)
  final Color tertiary; // highlights (yellow role)
  final Color background;
  final List<Color> header;
  final List<Color> warm;
  const Palette({
    required this.id,
    required this.name,
    required this.emoji,
    required this.primary,
    required this.primaryLight,
    required this.dark,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.header,
    required this.warm,
  });
}

const palettes = <Palette>[
  Palette(
    id: 'mango',
    name: 'مانجو',
    emoji: '🥭',
    primary: Color(0xFFEF6C00),
    primaryLight: Color(0xFFFFA726),
    dark: Color(0xFF4E2A04),
    secondary: Color(0xFF43A047),
    tertiary: Color(0xFFFFC107),
    background: Color(0xFFFFF8EE),
    header: [Color(0xFFFF8F00), Color(0xFFFFB300), Color(0xFFFFD54F)],
    warm: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
  ),
  Palette(
    id: 'garden',
    name: 'حديقة',
    emoji: '🥬',
    primary: Color(0xFF5E9E2F),
    primaryLight: Color(0xFF8BC34A),
    dark: Color(0xFF243B16),
    secondary: Color(0xFFF57C00),
    tertiary: Color(0xFFFFB300),
    background: Color(0xFFFBF8F0),
    header: [Color(0xFF6DAA35), Color(0xFF9CC94A), Color(0xFFFFC94A)],
    warm: [Color(0xFFFFB300), Color(0xFFF57C00)],
  ),
  Palette(
    id: 'lime',
    name: 'ليمون أخضر',
    emoji: '🍋',
    primary: Color(0xFF7CB342),
    primaryLight: Color(0xFFC0CA33),
    dark: Color(0xFF33401A),
    secondary: Color(0xFFFF7043),
    tertiary: Color(0xFFFFEB3B),
    background: Color(0xFFFCFDF3),
    header: [Color(0xFF9CCC65), Color(0xFFD4E157), Color(0xFFFFEE58)],
    warm: [Color(0xFFFF8A65), Color(0xFFF4511E)],
  ),
  Palette(
    id: 'dates',
    name: 'تمر وقهوة',
    emoji: '🌴',
    primary: Color(0xFF8D5524),
    primaryLight: Color(0xFFC68642),
    dark: Color(0xFF3E2410),
    secondary: Color(0xFF558B2F),
    tertiary: Color(0xFFE0A526),
    background: Color(0xFFFBF5EC),
    header: [Color(0xFF8D5524), Color(0xFFC68642), Color(0xFFE8C07D)],
    warm: [Color(0xFFE0A526), Color(0xFFB7791F)],
  ),
  Palette(
    id: 'sea',
    name: 'بحر ومرجان',
    emoji: '🌊',
    primary: Color(0xFF00897B),
    primaryLight: Color(0xFF4DB6AC),
    dark: Color(0xFF00352F),
    secondary: Color(0xFFFF7043),
    tertiary: Color(0xFFFFCA28),
    background: Color(0xFFF3FAF8),
    header: [Color(0xFF00897B), Color(0xFF26A69A), Color(0xFF80CBC4)],
    warm: [Color(0xFFFFAB91), Color(0xFFFF7043)],
  ),
  Palette(
    id: 'pomegranate',
    name: 'رمان',
    emoji: '🍎',
    primary: Color(0xFFC62828),
    primaryLight: Color(0xFFEF5350),
    dark: Color(0xFF4A0E0E),
    secondary: Color(0xFF2E7D32),
    tertiary: Color(0xFFFFB300),
    background: Color(0xFFFFF7F5),
    header: [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFFF8A65)],
    warm: [Color(0xFFFFB300), Color(0xFFFF8F00)],
  ),
  Palette(
    id: 'saffron',
    name: 'زعفران',
    emoji: '🌼',
    primary: Color(0xFFF9A825),
    primaryLight: Color(0xFFFFD54F),
    dark: Color(0xFF3D2E00),
    secondary: Color(0xFF6A1B9A),
    tertiary: Color(0xFFFF7043),
    background: Color(0xFFFFFCF0),
    header: [Color(0xFFF9A825), Color(0xFFFFCA28), Color(0xFFFFE082)],
    warm: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
  ),
  Palette(
    id: 'olive',
    name: 'زيتون',
    emoji: '🫒',
    primary: Color(0xFF6B7B3A),
    primaryLight: Color(0xFF9CAF5A),
    dark: Color(0xFF2B3218),
    secondary: Color(0xFFD84315),
    tertiary: Color(0xFFE6B655),
    background: Color(0xFFF8F7EF),
    header: [Color(0xFF55632B), Color(0xFF7D8F45), Color(0xFFB8C47A)],
    warm: [Color(0xFFFF8A50), Color(0xFFD84315)],
  ),
];

Palette paletteById(String id) =>
    palettes.firstWhere((p) => p.id == id, orElse: () => palettes.first);

/// The current palette, read everywhere through these names.
class Brand {
  static Palette current = palettes.first;

  static Color get green => current.primary;
  static Color get greenLight => current.primaryLight;
  static Color get greenDark => current.dark;
  static Color get orange => current.secondary;
  static Color get yellow => current.tertiary;
  static Color get cream => current.background;

  static LinearGradient get headerGradient => LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: current.header,
      );

  static LinearGradient get warmGradient => LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: current.warm,
      );
}

ThemeData buildTheme(Brightness b, Palette pal) {
  final dark = b == Brightness.dark;
  final cs = ColorScheme.fromSeed(
    seedColor: pal.primary,
    brightness: b,
    primary: dark ? pal.primaryLight : pal.primary,
    secondary: pal.secondary,
    tertiary: pal.tertiary,
    surface: dark ? const Color(0xFF16171A) : pal.background,
  );
  final radius = BorderRadius.circular(20);
  final cardColor = dark ? const Color(0xFF22242A) : Colors.white;
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
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
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
      fillColor: cardColor,
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
      selectedColor: pal.dark,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: cs.onSurface),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: pal.tertiary.withValues(alpha: 0.35),
      labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
  );
}
