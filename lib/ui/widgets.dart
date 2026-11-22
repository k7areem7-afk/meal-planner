import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';

/// Emoji tile used instead of photos.
class FoodTile extends StatelessWidget {
  final String emoji;
  final double size;
  const FoodTile(this.emoji, {super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

class BudgetBar extends StatelessWidget {
  final double total;
  final double budget;
  final String label;
  const BudgetBar(
      {super.key,
      required this.total,
      required this.budget,
      this.label = 'تكلفة المشتريات التقديرية'});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ratio = budget <= 0 ? 0.0 : (total / budget);
    final over = total > budget;
    final color = over
        ? cs.error
        : (ratio > 0.9 ? Colors.orange.shade700 : Colors.green.shade700);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(fmtMoney(total),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text('من ${fmtMoney(budget)}'),
                ),
                const Spacer(),
                Text(
                  over
                      ? 'تجاوز ${fmtMoney(total - budget)}'
                      : 'متبقي ${fmtMoney(budget - total)}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0).toDouble(),
                minHeight: 10,
                color: color,
                backgroundColor: cs.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multi or single choice chips.
class ChoiceChips extends StatelessWidget {
  final Map<String, String> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;
  const ChoiceChips(
      {super.key,
      required this.options,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final e in options.entries)
          FilterChip(
            label: Text(e.value),
            selected: selected.contains(e.key),
            onSelected: (_) => onTap(e.key),
          ),
      ],
    );
  }
}

class InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoPill(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: cs.onSecondaryContainer),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: cs.onSecondaryContainer)),
      ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      );
}

const _days = [
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد'
];

String dayName(DateTime d) => _days[d.weekday - 1];

String recipeSubtitle(Recipe r, double costPerServing) =>
    '${r.minutes} دقيقة · ${fmtMoney(costPerServing)} للحصة · ${r.kcal} سعرة';

Future<double?> askNumber(BuildContext context,
    {required String title,
    required double initial,
    String suffix = '',
    String? hint}) async {
  final ctrl = TextEditingController(
      text: initial == initial.roundToDouble()
          ? initial.round().toString()
          : initial.toString());
  return showDialog<double>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(suffixText: suffix, helperText: hint),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx, parseNumber(ctrl.text));
          },
          child: const Text('حفظ'),
        ),
      ],
    ),
  );
}

/// Accepts Western and Arabic-Indic digits and either decimal mark.
double? parseNumber(String text) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final b = StringBuffer();
  for (final ch in text.trim().split('')) {
    final i = arabic.indexOf(ch);
    if (i >= 0) {
      b.write(i);
    } else if (ch == '٫' || ch == ',') {
      b.write('.');
    } else {
      b.write(ch);
    }
  }
  return double.tryParse(b.toString());
}
