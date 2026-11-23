import '../i18n.dart';
import 'package:flutter/material.dart';

import 'ai_screen.dart';
import 'grocery_screen.dart';
import 'plan_screen.dart';
import 'recipes_screen.dart';
import 'settings_screen.dart';

/// Lets tab screens show a back button that returns to the plan.
class ShellScope extends InheritedWidget {
  final int index;
  final VoidCallback goHome;
  const ShellScope(
      {super.key,
      required this.index,
      required this.goHome,
      required super.child});
  static ShellScope? of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<ShellScope>();
  @override
  bool updateShouldNotify(ShellScope old) => old.index != index;
}

/// AppBar leading for tab screens.
class ShellBack extends StatelessWidget {
  const ShellBack({super.key});
  @override
  Widget build(BuildContext context) {
    final s = ShellScope.of(context);
    if (s == null || s.index == 0) return const SizedBox.shrink();
    return BackButton(onPressed: s.goHome);
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [
      PlanScreen(),
      GroceryScreen(),
      AiScreen(),
      RecipesScreen(),
      SettingsScreen(),
    ];
    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => index = 0);
      },
      child: ShellScope(
        index: index,
        goHome: () => setState(() => index = 0),
        child: _scaffold(pages),
      ),
    );
  }

  Widget _scaffold(List<Widget> pages) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: tx('الخطة', 'Plan')),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: tx('المشتريات', 'Shopping')),
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: tx('اقترح لي', 'Suggest')),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: tx('الوصفات', 'Recipes')),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: tx('الإعدادات', 'Settings')),
        ],
      ),
    );
  }
}
