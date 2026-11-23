import '../i18n.dart';
import 'package:flutter/material.dart';

import '../state.dart';
import 'anim.dart';
import 'theme.dart';

/// Pick the app's colors. Changes apply immediately.
class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tx('ألوان التطبيق 🎨', 'App colors 🎨'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tx('اختار الألوان اللي تعجبك، وتتغير على طول:', 'Pick the colors you like. They change right away:'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: palettes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (_, i) => FadeSlideIn(
              index: i,
              child: _PaletteCard(
                palette: palettes[i],
                selected: app.themeId == palettes[i].id,
                onTap: () => app.setTheme(palettes[i].id),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(tx('الوضع', 'Mode'), style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                  value: 'system',
                  icon: Icon(Icons.brightness_auto),
                  label: Text(tx('تلقائي', 'System'))),
              ButtonSegment(
                  value: 'light',
                  icon: Icon(Icons.light_mode),
                  label: Text(tx('فاتح', 'Light'))),
              ButtonSegment(
                  value: 'dark',
                  icon: Icon(Icons.dark_mode),
                  label: Text(tx('داكن', 'Dark'))),
            ],
            selected: {app.themeMode},
            onSelectionChanged: (s) => app.setThemeMode(s.first),
          ),
        ],
      ),
    );
  }
}

class _PaletteCard extends StatelessWidget {
  final Palette palette;
  final bool selected;
  final VoidCallback onTap;
  const _PaletteCard(
      {required this.palette, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = palette;
    Widget dot(Color c) => Container(
          width: 22,
          height: 22,
          margin: const EdgeInsetsDirectional.only(end: 6),
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        );
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: p.background,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: selected ? p.primary : Colors.black12,
              width: selected ? 3 : 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: p.header,
                ),
              ),
              alignment: Alignment.center,
              child: Text(p.emoji, style: const TextStyle(fontSize: 34)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(p.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: p.dark)),
                      ),
                      if (selected)
                        Icon(Icons.check_circle, color: p.primary),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      dot(p.primary),
                      dot(p.secondary),
                      dot(p.tertiary),
                    ]),
                    const Spacer(),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: p.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tx('زر', 'Button'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: p.secondary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: p.tertiary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
