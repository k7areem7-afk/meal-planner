import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'state.dart';
import 'ui/onboarding.dart';
import 'ui/shell.dart';

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
    const seed = Color(0xFF2E7D32);
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      home: !app.loaded
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (app.onboarded ? const Shell() : const OnboardingScreen()),
    );
  }
}
