import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'pref_editors.dart';
import 'price_editor.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.prefs;

    String join(Iterable<String> ids, Map<String, String> names) {
      final l = ids.map((e) => names[e] ?? e).toList();
      return l.isEmpty ? 'لا شيء' : l.join('، ');
    }

    final summary = {
      PrefSection.store: app.c.store(p.storeId).name,
      PrefSection.budget: '${fmtMoney(p.budget)} في الأسبوع',
      PrefSection.people: '${p.people} ${p.people == 1 ? 'شخص' : 'أشخاص'}',
      PrefSection.meals:
          '${slotOrder.where(p.meals.contains).map((s) => slotNames[s]!).join('، ')}${p.leftovers ? ' · طبخة تكفي يومين' : ''}',
      PrefSection.diet: dietNames[p.diet] ?? p.diet,
      PrefSection.styles: join(p.styles,
          {for (final s in app.c.styles) s.id: s.name}),
      PrefSection.allergies: join(p.allergies, allergyNames),
      PrefSection.dislikes: join(p.dislikes, dislikeNames),
      PrefSection.appliances: join(p.appliances,
          {for (final e in applianceNames.entries) e.key: e.value.$1}),
      PrefSection.fridge: join(p.fridge,
          {for (final i in app.c.ingredients.values) i.id: i.name}),
    };
    const icons = {
      PrefSection.store: Icons.storefront_outlined,
      PrefSection.budget: Icons.account_balance_wallet_outlined,
      PrefSection.people: Icons.people_outline,
      PrefSection.meals: Icons.restaurant_outlined,
      PrefSection.diet: Icons.eco_outlined,
      PrefSection.styles: Icons.public,
      PrefSection.allergies: Icons.warning_amber_outlined,
      PrefSection.dislikes: Icons.thumb_down_outlined,
      PrefSection.appliances: Icons.kitchen_outlined,
      PrefSection.fridge: Icons.kitchen,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(children: [
        const _Header('التفضيلات'),
        for (final e in summary.entries)
          ListTile(
            leading: Icon(icons[e.key]),
            title: Text(prefTitles[e.key]!.$1),
            subtitle: Text(e.value, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PrefEditPage(e.key))),
          ),
        const Divider(),
        const _Header('الأسعار'),
        ListTile(
          leading: const Icon(Icons.price_change_outlined),
          title: const Text('تعديل أسعار المكونات'),
          subtitle: Text(
              '${app.overrides.keys.where((k) => k.startsWith('${p.storeId}|')).length} سعر معدّل في هذا المتجر'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PriceEditor())),
        ),
        const Divider(),
        const _Header('البيانات'),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text('ابدأ من جديد'),
          subtitle: const Text('يمسح التفضيلات والخطة والأسعار المعدلة'),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('مسح كل البيانات؟'),
                content: const Text('ما تقدر تتراجع عن هذا.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('إلغاء')),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(ctx).colorScheme.error),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('امسح')),
                ],
              ),
            );
            if (ok == true) app.resetAll();
          },
        ),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'سفرة',
          applicationVersion: '0.2.0',
          aboutBoxChildren: [
            Text(
                'مخطط وجبات أسبوعي بالميزانية. الأسعار والقيم الغذائية تقديرية.'),
          ],
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
      );
}
