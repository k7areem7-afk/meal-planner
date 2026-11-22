import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'widgets.dart';

class PriceEditor extends StatefulWidget {
  const PriceEditor({super.key});
  @override
  State<PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<PriceEditor> {
  String q = '';
  bool onlyPlan = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pr = app.pricing;
    final inPlan = <String>{
      for (final m in app.plan)
        ...?app.c.recipeById[m.recipeId]?.lines.map((l) => l.ingId)
    };
    final list = app.c.ingredients.values
        .where((i) => q.isEmpty || i.name.contains(q))
        .where((i) => !onlyPlan || inPlan.contains(i.id))
        .toList()
      ..sort((a, b) {
        final ai = app.c.aisles.indexWhere((x) => x.id == a.aisle);
        final bi = app.c.aisles.indexWhere((x) => x.id == b.aisle);
        return ai != bi ? ai.compareTo(bi) : a.name.compareTo(b.name);
      });

    return Scaffold(
      appBar: AppBar(
          title: Text('الأسعار في ${app.c.store(app.prefs.storeId).name}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const Text(
              'الأسعار تقديرية. عدّل أي سعر حسب فاتورتك وكل الحسابات تتحدث. التعديل يخص المتجر المختار فقط.'),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث عن مكوّن',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => q = v.trim()),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('مكونات خطة هذا الأسبوع فقط'),
            value: onlyPlan,
            onChanged: (v) => setState(() => onlyPlan = v),
          ),
          for (final i in list)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(i.name),
              subtitle: Text(
                  '${app.c.aisleName(i.aisle)} · العبوة ${fmtPack(pr.packSize(i), i)}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (pr.override(i.id) != null)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(end: 6),
                    child: Icon(Icons.edit, size: 16),
                  ),
                Text(fmtMoney(pr.packPrice(i)),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              onTap: () => editPriceDialog(context, i),
            ),
        ],
      ),
    );
  }
}

Future<void> editPriceDialog(BuildContext context, Ingredient i) async {
  final app = AppScope.read(context);
  final pr = app.pricing;
  final pack = TextEditingController(text: _clean(pr.packSize(i)));
  final price = TextEditingController(text: _clean(pr.packPrice(i)));
  final res = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(i.name),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: pack,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              labelText: 'حجم العبوة', suffixText: unitLabel(i)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: price,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
              labelText: 'سعر العبوة', suffixText: 'ر.س'),
        ),
      ]),
      actions: [
        if (pr.override(i.id) != null)
          TextButton(
              onPressed: () => Navigator.pop(ctx, 'reset'),
              child: const Text('السعر الافتراضي')),
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, 'save'),
            child: const Text('حفظ')),
      ],
    ),
  );
  if (res == 'reset') {
    app.resetPrice(i.id);
  } else if (res == 'save') {
    final p = parseNumber(pack.text);
    final v = parseNumber(price.text);
    if (p != null && p > 0 && v != null && v >= 0) app.setPrice(i.id, p, v);
  }
}

String _clean(double v) => v == v.roundToDouble()
    ? v.round().toString()
    : v.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
