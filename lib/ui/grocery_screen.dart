import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'price_editor.dart';
import 'widgets.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pr = app.pricing;
    final lines = groceryLines(app.c, pr, app.plan);
    final visible = lines
        .where((g) => !app.have.contains(g.ing.id))
        .where((g) => app.showPantry || !g.ing.pantry)
        .toList();
    final haveLines =
        lines.where((g) => app.have.contains(g.ing.id)).toList();
    final hiddenPantry =
        lines.where((g) => g.ing.pantry && !app.have.contains(g.ing.id)).length;

    final byAisle = <String, List<GroceryLine>>{};
    for (final g in visible) {
      byAisle.putIfAbsent(g.ing.aisle, () => []).add(g);
    }
    for (final l in byAisle.values) {
      l.sort((a, b) => a.ing.name.compareTo(b.ing.name));
    }

    final customTotal = app.custom.fold<double>(0, (a, c) => a + c.price);
    final total = app.total + customTotal;
    final left = visible
            .where((g) => !app.checked.contains(g.ing.id))
            .fold<double>(0, (a, g) => g.ing.pantry ? a : a + g.cost) +
        app.custom
            .where((c) => !app.checked.contains(c.id))
            .fold<double>(0, (a, c) => a + c.price);
    final count = visible.length + app.custom.length;
    final done = visible.where((g) => app.checked.contains(g.ing.id)).length +
        app.custom.where((c) => app.checked.contains(c.id)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المشتريات'),
        actions: [
          IconButton(
            tooltip: 'نسخ القائمة',
            icon: const Icon(Icons.copy_all),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _asText(app, byAisle)));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('نُسخت القائمة، الصقها في واتساب')));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'pantry':
                  app.setShowPantry(!app.showPantry);
                case 'clear':
                  app.clearChecked();
                case 'prices':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PriceEditor()));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: 'pantry',
                  child: Text(app.showPantry
                      ? 'إخفاء أساسيات المطبخ'
                      : 'إظهار أساسيات المطبخ')),
              const PopupMenuItem(value: 'clear', child: Text('إلغاء كل التأشير')),
              const PopupMenuItem(value: 'prices', child: Text('تعديل الأسعار')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'أضف عنصراً',
        onPressed: () => _addCustom(context),
        child: const Icon(Icons.add),
      ),
      body: app.plan.isEmpty && app.custom.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('🛒\nالقائمة فاضية. اصنع خطة الأسبوع أولاً.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
              children: [
                BudgetBar(
                    total: total,
                    budget: app.prefs.budget,
                    label: 'المجموع التقديري عند الكاشير'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'اشتريت $done من $count · المتبقي ${fmtMoney(left)} · ${app.c.store(app.prefs.storeId).name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (!app.showPantry && hiddenPantry > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Text(
                      'مخفي $hiddenPantry من أساسيات المطبخ (ملح، بهارات، زيت...). أظهرها من القائمة ⋮.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                for (final a in app.c.aisles)
                  if (byAisle.containsKey(a.id)) ...[
                    SectionTitle(a.name),
                    Card(
                      child: Column(children: [
                        for (final g in byAisle[a.id]!) _line(context, app, pr, g),
                      ]),
                    ),
                  ],
                if (app.custom.isNotEmpty) ...[
                  const SectionTitle('أضفتها بنفسك'),
                  Card(
                    child: Column(children: [
                      for (final c in app.custom)
                        CheckboxListTile(
                          value: app.checked.contains(c.id),
                          onChanged: (_) => app.toggleChecked(c.id),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(c.name,
                              style: TextStyle(
                                  decoration: app.checked.contains(c.id)
                                      ? TextDecoration.lineThrough
                                      : null)),
                          subtitle: c.note.isEmpty ? null : Text(c.note),
                          secondary: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (c.price > 0) Text(fmtMoney(c.price)),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => app.removeCustom(c),
                              ),
                            ],
                          ),
                        ),
                    ]),
                  ),
                ],
                if (haveLines.isNotEmpty) ...[
                  const SectionTitle('موجود عندي (ما ينحسب)'),
                  Card(
                    child: Column(children: [
                      for (final g in haveLines)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.home_outlined),
                          title: Text(g.ing.name),
                          subtitle: Text('تحتاج ${fmtBase(g.amount, g.ing)}'),
                          trailing: TextButton(
                            onPressed: () => app.toggleHave(g.ing.id),
                            child: const Text('أرجعه للقائمة'),
                          ),
                        ),
                    ]),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _line(
      BuildContext context, AppState app, Pricing pr, GroceryLine g) {
    final checked = app.checked.contains(g.ing.id);
    final size = pr.packSize(g.ing);
    final edited = pr.override(g.ing.id) != null;
    return CheckboxListTile(
      value: checked,
      onChanged: (_) => app.toggleChecked(g.ing.id),
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(g.ing.name,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: checked ? TextDecoration.lineThrough : null)),
      subtitle: Text(
          'تحتاج ${fmtBase(g.amount, g.ing)} · ${g.packs} × ${fmtPack(size, g.ing)}'
          '${g.recipeIds.length > 1 ? ' · لـ ${g.recipeIds.length} وصفات' : ''}'),
      secondary: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _itemMenu(context, app, pr, g),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(g.ing.pantry ? '—' : fmtMoney(g.cost),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Icon(edited ? Icons.edit : Icons.more_horiz,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  void _itemMenu(
      BuildContext context, AppState app, Pricing pr, GroceryLine g) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text(g.ing.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                'العبوة ${fmtPack(pr.packSize(g.ing), g.ing)} بـ ${fmtMoney(pr.packPrice(g.ing))}'),
          ),
          ListTile(
            leading: const Icon(Icons.price_change_outlined),
            title: const Text('عدّل السعر أو حجم العبوة'),
            onTap: () {
              Navigator.pop(ctx);
              editPriceDialog(context, g.ing);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('موجود عندي في البيت'),
            subtitle: const Text('ما ينحسب في المجموع، ويبقى كذا للأسابيع الجاية'),
            onTap: () {
              Navigator.pop(ctx);
              app.toggleHave(g.ing.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text('يستخدم في: ${g.recipeIds.map((id) => app.c.recipeById[id]?.title ?? id).join('، ')}'),
          ),
        ]),
      ),
    );
  }

  Future<void> _addCustom(BuildContext context) async {
    final app = AppScope.read(context);
    final name = TextEditingController();
    final note = TextEditingController();
    final price = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('أضف للقائمة'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'الاسم (مثلاً: مناديل)')),
          TextField(
              controller: note,
              decoration: const InputDecoration(labelText: 'الكمية أو ملاحظة')),
          TextField(
              controller: price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'السعر التقريبي (اختياري)', suffixText: 'ر.س')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('أضف')),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      app.addCustom(name.text.trim(), note.text.trim(),
          parseNumber(price.text) ?? 0);
    }
  }

  String _asText(AppState app, Map<String, List<GroceryLine>> byAisle) {
    final b = StringBuffer('🛒 قائمة المشتريات\n');
    for (final a in app.c.aisles) {
      final l = byAisle[a.id];
      if (l == null) continue;
      b.writeln('\n${a.name}:');
      for (final g in l) {
        final mark = app.checked.contains(g.ing.id) ? '✅' : '▫️';
        b.writeln('$mark ${g.ing.name} — ${fmtBase(g.amount, g.ing)}');
      }
    }
    if (app.custom.isNotEmpty) {
      b.writeln('\nأخرى:');
      for (final c in app.custom) {
        b.writeln('▫️ ${c.name}${c.note.isEmpty ? '' : ' — ${c.note}'}');
      }
    }
    return b.toString();
  }
}
