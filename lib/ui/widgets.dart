import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import 'anim.dart';
import 'theme.dart';

/// Emoji tile used instead of photos.
class FoodTile extends StatelessWidget {
  final String emoji;
  final double size;
  const FoodTile(this.emoji, {super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Brand.yellow.withValues(alpha: 0.25),
            Brand.greenLight.withValues(alpha: 0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.52)),
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
        : (ratio > 0.9 ? Brand.orange : Brand.green);
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
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: total),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => Text(fmtMoney(v),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800, color: color)),
                ),
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
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedBar(value: ratio, color: color),
            if (total < 0.01)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                    '🧊 التكلفة صفر لأن كل مكونات الخطة متعلّمة إنها موجودة عندك. لو مو صحيح، عدّل "الموجود عندك".',
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
              ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 kcal · بروتين · كارب · دهون
class MacroRow extends StatelessWidget {
  final num kcal, protein, carbs, fat;
  final bool compact;
  const MacroRow(
      {super.key,
      required this.kcal,
      required this.protein,
      required this.carbs,
      required this.fat,
      this.compact = true});

  factory MacroRow.of(Recipe r, {bool compact = true}) => MacroRow(
      kcal: r.kcal,
      protein: r.protein,
      carbs: r.carbs,
      fat: r.fat,
      compact: compact);

  @override
  Widget build(BuildContext context) {
    Widget pill(String label, String v, Color c) => Container(
          margin: const EdgeInsetsDirectional.only(end: 4, top: 4),
          padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 10, vertical: compact ? 2 : 6),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$label $v',
              style: TextStyle(
                  fontSize: compact ? 11 : 13,
                  fontWeight: FontWeight.w700,
                  color: c)),
        );
    return Wrap(children: [
      pill('🔥', '${kcal.round()}', Brand.orange),
      pill('بروتين', '${protein.round()}غ', Brand.green),
      pill('كارب', '${carbs.round()}غ', const Color(0xFFB8860B)),
      pill('دهون', '${fat.round()}غ', const Color(0xFF8D6E63)),
    ]);
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
                ?.copyWith(fontWeight: FontWeight.w800)),
      );
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

/// Card grid like the reference screens: icon tile, bold title, grey line.
class OptionGrid extends StatelessWidget {
  final List<Option> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;
  final int columns;
  final double aspect;
  const OptionGrid(
      {super.key,
      required this.options,
      required this.selected,
      required this.onTap,
      this.columns = 2,
      this.aspect = 0.98});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspect,
      ),
      itemBuilder: (_, i) => FadeSlideIn(
        index: i,
        child: OptionCard(
          option: options[i],
          selected: selected.contains(options[i].id),
          onTap: () => onTap(options[i].id),
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final Option option;
  final bool selected;
  final VoidCallback onTap;
  final bool horizontal;
  const OptionCard(
      {super.key,
      required this.option,
      required this.selected,
      required this.onTap,
      this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final icon = Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? Brand.yellow.withValues(alpha: 0.3)
            : cs.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(option.emoji, style: const TextStyle(fontSize: 25)),
    );
    final texts = <Widget>[
      Text(option.title,
          textAlign: horizontal ? TextAlign.start : TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
      if (option.sub.isNotEmpty) ...[
        const SizedBox(height: 2),
        Text(option.sub,
            textAlign: horizontal ? TextAlign.start : TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      ],
    ];
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected
              ? Brand.greenLight.withValues(alpha: dark ? 0.25 : 0.14)
              : (dark ? const Color(0xFF20261A) : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: selected
                  ? Brand.green
                  : cs.outlineVariant.withValues(alpha: 0.6),
              width: selected ? 2 : 1),
          boxShadow: [
            if (!dark)
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(children: [
          if (horizontal)
            Row(children: [
              icon,
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: texts)),
              const SizedBox(width: 28),
            ])
          else
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [icon, const SizedBox(height: 6), ...texts],
              ),
            ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: AnimatedScale(
              scale: selected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(Icons.check_circle, color: Brand.green),
            ),
          ),
        ]),
      ),
    );
  }
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
    '${r.minutes} دقيقة · ${fmtMoney(costPerServing)} للحصة';

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
          onPressed: () => Navigator.pop(ctx, parseNumber(ctrl.text)),
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
