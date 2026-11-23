import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../notify.dart';
import '../state.dart';
import 'theme.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});
  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  NotifSettings? _s;
  NotifSettings get s => _s!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _s ??= AppScope.read(context).notif.copy();
  }

  void _save() => AppScope.read(context).setNotif(s.copy());

  Future<void> _pickTime(String key, {bool shopping = false}) async {
    final cur = shopping ? s.shoppingTime : s.times[key]!;
    final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: cur ~/ 60, minute: cur % 60));
    if (t == null) return;
    setState(() {
      final v = t.hour * 60 + t.minute;
      if (shopping) {
        s.shoppingTime = v;
      } else {
        s.times[key] = v;
      }
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final days = [
      (DateTime.saturday, tx('السبت', 'Saturday')),
      (DateTime.sunday, tx('الأحد', 'Sunday')),
      (DateTime.monday, tx('الاثنين', 'Monday')),
      (DateTime.tuesday, tx('الثلاثاء', 'Tuesday')),
      (DateTime.wednesday, tx('الأربعاء', 'Wednesday')),
      (DateTime.thursday, tx('الخميس', 'Thursday')),
      (DateTime.friday, tx('الجمعة', 'Friday')),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(tx('التنبيهات', 'Reminders'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              secondary: const Text('🔔', style: TextStyle(fontSize: 26)),
              title: Text(tx('تشغيل التنبيهات', 'Turn on reminders'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(tx('نذكرك متى تبدأ الطبخ ووقت كل وجبة',
                  'We remind you when to start cooking and at meal times')),
              value: s.enabled,
              onChanged: (v) async {
                if (v) {
                  final ok = await Notifier.requestPermission();
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(tx(
                            'اسمح للتطبيق بالإشعارات من إعدادات الجوال',
                            'Allow notifications for the app in phone settings'))));
                  }
                }
                setState(() => s.enabled = v);
                _save();
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(tx('🕐 مواعيد الوجبات', '🕐 Meal times'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Card(
            child: Column(children: [
              for (final slot in slotOrder)
                ListTile(
                  leading: Text({'b': '🍳', 'l': '🍛', 'd': '🥗'}[slot]!,
                      style: const TextStyle(fontSize: 24)),
                  title: Text(slotNames[slot]!),
                  trailing: Text(hhmm(s.times[slot]!),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Brand.green)),
                  onTap: () => _pickTime(slot),
                ),
            ]),
          ),
          const SizedBox(height: 12),
          Text(tx('وش نذكرك فيه؟', 'What should we remind you about?'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Card(
            child: Column(children: [
              SwitchListTile(
                secondary: const Text('🍳', style: TextStyle(fontSize: 22)),
                title: Text(tx('متى أبدأ الطبخ', 'When to start cooking')),
                subtitle: Text(tx(
                    'نحسب وقت تحضير الوصفة ونذكرك قبل الوجبة بوقت كافي (مثلاً كبسة 75 دقيقة ← نذكرك 12:35 لغداء الساعة 2)',
                    'We use each recipe’s cooking time and remind you early enough (e.g. 75-min kabsa → 12:35 for a 2 PM lunch)')),
                value: s.startCooking,
                onChanged: (v) {
                  setState(() => s.startCooking = v);
                  _save();
                },
              ),
              SwitchListTile(
                secondary: const Text('🍽️', style: TextStyle(fontSize: 22)),
                title: Text(tx('وقت الوجبة', 'Meal time')),
                value: s.mealTime,
                onChanged: (v) {
                  setState(() => s.mealTime = v);
                  _save();
                },
              ),
              SwitchListTile(
                secondary: const Text('🌙', style: TextStyle(fontSize: 22)),
                title: Text(tx('تجهيزات الليلة اللي قبلها', 'Night-before prep')),
                subtitle: Text(tx(
                    'طلّع اللحم من الفريزر، انقع الفول أو الحمص... الساعة 9 بالليل',
                    'Move meat from the freezer, soak beans... at 9 PM')),
                value: s.prepNight,
                onChanged: (v) {
                  setState(() => s.prepNight = v);
                  _save();
                },
              ),
              SwitchListTile(
                secondary: const Text('🛒', style: TextStyle(fontSize: 22)),
                title: Text(tx('يوم المشتريات الأسبوعي', 'Weekly shopping day')),
                value: s.shopping,
                onChanged: (v) {
                  setState(() => s.shopping = v);
                  _save();
                },
              ),
              if (s.shopping)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: s.shoppingWeekday,
                        items: [
                          for (final (v, n) in days)
                            DropdownMenuItem(value: v, child: Text(n)),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => s.shoppingWeekday = v);
                          _save();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => _pickTime('', shopping: true),
                      child: Text(hhmm(s.shoppingTime)),
                    ),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            color: Brand.yellow.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(tx(
                  '⏰ مؤقت الطبخ: لما تشغّل مؤقت في "ابدأ الطبخ" بيرن تنبيه حتى لو طلعت من التطبيق، عشان ما تنسى الأكل على النار.',
                  '⏰ Cooking timer: a timer started in "Start cooking" rings even if you leave the app, so food never burns.')),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Notifier.requestPermission();
              await Notifier.test();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(tx('بيوصلك تنبيه تجريبي بعد 5 ثواني',
                        'A test reminder arrives in 5 seconds'))));
              }
            },
            icon: const Icon(Icons.notifications_active_outlined),
            label: Text(tx('جرّب تنبيه', 'Send a test')),
          ),
        ],
      ),
    );
  }
}
