import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'state.dart';
import 'ui/onboarding.dart';
import 'ui/shell.dart';
import 'ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  state.load();
  runApp(AppScope(state: state, child: const SufraApp()));
}

class SufraApp extends StatelessWidget {
  const SufraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pal = paletteById(app.themeId);
    Brand.current = pal;
    return MaterialApp(
      title: 'سفرة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(Brightness.light, pal),
      darkTheme: buildTheme(Brightness.dark, pal),
      themeMode: app.themeMode == 'light'
          ? ThemeMode.light
          : (app.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.system),
      home: !app.loaded
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (app.onboarded ? const Shell() : const OnboardingScreen()),
    );
  }
}
