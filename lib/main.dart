import 'i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n.dart';
import 'notify.dart';
import 'state.dart';
import 'ui/onboarding.dart';
import 'ui/shell.dart';
import 'ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  state.load().then((_) async {
    await Notifier.init();
    if (state.onboarded) Notifier.schedulePlan(state);
  });
  runApp(AppScope(state: state, child: const SufraApp()));
}

class SufraApp extends StatelessWidget {
  const SufraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pal = paletteById(app.themeId);
    Brand.current = pal;
    L.en = app.lang == 'en';
    return MaterialApp(
      title: tx('سفرة', 'Sufra'),
      debugShowCheckedModeBanner: false,
      locale: Locale(app.lang),
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
