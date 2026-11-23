import '../i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine.dart';
import '../state.dart';
import 'shell.dart';
import 'price_editor.dart';
import 'widgets.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pr = app.pricing;
    final lines = groceryLines(app.c, pr, app.plan);
    final visible =
        lines.where((g) => !app.have.contains(g.ing.id)).toList();
    final haveLines =
        lines.where((g) => app.have.contains(g.ing.id)).toList();

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
            .fold<double>(0, (a, g) => a + g.cost) +
        app.custom
            .where((c) => !app.checked.contains(c.id))
            .fold<double>(0, (a, c) => a + c.price);
    final count = visible.length + app.custom.length;
    final done = visible.where((g) => app.checked.contains(g.ing.id)).length +
        app.custom.where((c) => app.checked.contains(c.id)).length;

    return Scaffold(
      appBar: AppBar(
        leading: const ShellBack(),
        title: Text(tx('قائمة المشتريات', 'Shopping list')),
        actions: [
          IconButton(
            tooltip: tx('نسخ القائمة', 'Copy list'),
            icon: const Icon(Icons.copy_all),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _asText(app, byAisle)));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tx('نُسخت القائمة، الصقها في واتساب', 'List copied. Paste it in WhatsApp'))));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'clear':
                  app.clearChecked();
                case 'prices':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PriceEditor()));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'clear', child: Text(tx('إلغاء كل التأشير', 'Uncheck all'))),
              PopupMenuItem(value: 'prices', child: Text(tx('تعديل الأسعار', 'Edit prices'))),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: tx('أضف عنصراً', 'Add item'),
        onPressed: () => _addCustom(context),
        child: const Icon(Icons.add),
      ),
      body: app.plan.isEmpty && app.custom.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(tx('🛒\nالقائمة فاضية. اصنع خطة الأسبوع أولاً.', '🛒\nThe list is empty. Make the week’s plan first.'),
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
                    label: tx('المجموع التقديري عند الكاشير', 'Estimated total at the checkout')),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    tx('اشتريت $done من $count · المتبقي ${fmtMoney(left)} · ${app.c.store(app.prefs.storeId).name}', 'Bought $done of $count · left ${fmtMoney(left)} · ${app.c.store(app.prefs.storeId).name}'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    tx('اللي عندك في الثلاجة أو المطبخ (ومنها البهارات) ما يظهر هنا. عدّلها من زر الثلاجة 🧊 في الخطة.', 'What you have in the fridge or kitchen (spices too) is not listed here. Change it with the fridge button 🧊 on the plan.'),
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
                  SectionTitle(tx('أضفتها بنفسك', 'Added by you')),
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
                  SectionTitle(tx('موجود عندي (ما ينحسب)', 'Already at home (not counted)')),
                  Card(
                    child: Column(children: [
                      for (final g in haveLines)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.home_outlined),
                          title: Text(g.ing.name),
                          subtitle: Text(tx('تحتاج ${fmtBase(g.amount, g.ing)}', 'Need ${fmtBase(g.amount, g.ing)}')),
                          trailing: TextButton(
                            onPressed: () => app.toggleHave(g.ing.id),
                            child: Text(tx('أرجعه للقائمة', 'Back to the list')),
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
      title: Text('${g.ing.emoji} ${g.ing.name}',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: checked ? TextDecoration.lineThrough : null)),
      subtitle: Text(
          tx('تحتاج ${fmtBase(g.amount, g.ing)} · ${g.packs} × ${fmtPack(size, g.ing)}', 'Need ${fmtBase(g.amount, g.ing)} · ${g.packs} × ${fmtPack(size, g.ing)}') +
          tx('${g.recipeIds.length > 1 ? ' · لـ ${g.recipeIds.length} وصفات' : ''}', '${g.recipeIds.length > 1 ? ' · for ${g.recipeIds.length} recipes' : ''}')),
      secondary: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _itemMenu(context, app, pr, g),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(fmtMoney(g.cost),
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
                tx('العبوة ${fmtPack(pr.packSize(g.ing), g.ing)} بـ ${fmtMoney(pr.packPrice(g.ing))}', 'Pack ${fmtPack(pr.packSize(g.ing), g.ing)} for ${fmtMoney(pr.packPrice(g.ing))}')),
          ),
          ListTile(
            leading: const Icon(Icons.price_change_outlined),
            title: Text(tx('عدّل السعر أو حجم العبوة', 'Edit price or pack size')),
            onTap: () {
              Navigator.pop(ctx);
              editPriceDialog(context, g.ing);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(tx('موجود عندي في البيت', 'I have this at home')),
            subtitle: Text(tx('ما ينحسب في المجموع، ويبقى كذا للأسابيع الجاية', 'Not counted in the total, and stays that way for the next weeks')),
            onTap: () {
              Navigator.pop(ctx);
              app.toggleHave(g.ing.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text(tx('يستخدم في: ${g.recipeIds.map((id) => app.c.recipeById[id]?.title ?? id).join('، ')}', 'Used in: ${g.recipeIds.map((id) => app.c.recipeById[id]?.title ?? id).join(', ')}')),
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
        title: Text(tx('أضف للقائمة', 'Add to list')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              autofocus: true,
              decoration: InputDecoration(labelText: tx('الاسم (مثلاً: مناديل)', 'Name (e.g. tissues)'))),
          TextField(
              controller: note,
              decoration: InputDecoration(labelText: tx('الكمية أو ملاحظة', 'Quantity or note'))),
          TextField(
              controller: price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: tx('السعر التقريبي (اختياري)', 'Approx. price (optional)'), suffixText: tx('ر.س', 'SAR'))),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(tx('إلغاء', 'Cancel'))),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(tx('أضف', 'Add'))),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      app.addCustom(name.text.trim(), note.text.trim(),
          parseNumber(price.text) ?? 0);
    }
  }

  String _asText(AppState app, Map<String, List<GroceryLine>> byAisle) {
    final b = StringBuffer(tx('🛒 قائمة المشتريات\n', '🛒 Shopping list\n'));
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
      b.writeln(tx('\nأخرى:', '\nOther:'));
      for (final c in app.custom) {
        b.writeln('▫️ ${c.name}${c.note.isEmpty ? '' : ' — ${c.note}'}');
      }
    }
    return b.toString();
  }
}
