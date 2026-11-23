// Local reminders: when to start cooking, meal time, the night-before prep,
// the weekly shopping trip and the cooking timer.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'i18n.dart';
import 'models.dart';
import 'state.dart';

class NotifSettings {
  bool enabled;
  Map<String, int> times; // minutes after midnight for b l d
  bool startCooking;
  bool mealTime;
  bool prepNight;
  bool shopping;
  int shoppingWeekday; // DateTime.monday..sunday
  int shoppingTime;

  NotifSettings({
    this.enabled = false,
    Map<String, int>? times,
    this.startCooking = true,
    this.mealTime = true,
    this.prepNight = true,
    this.shopping = true,
    this.shoppingWeekday = DateTime.thursday,
    this.shoppingTime = 18 * 60,
  }) : times = times ?? {'b': 8 * 60, 'l': 14 * 60, 'd': 20 * 60};

  NotifSettings copy() => NotifSettings.fromJson(toJson());

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'times': times,
        'startCooking': startCooking,
        'mealTime': mealTime,
        'prepNight': prepNight,
        'shopping': shopping,
        'shoppingWeekday': shoppingWeekday,
        'shoppingTime': shoppingTime,
      };

  factory NotifSettings.fromJson(Map<String, dynamic> j) => NotifSettings(
        enabled: j['enabled'] == true,
        times: ((j['times'] as Map?) ?? {'b': 480, 'l': 840, 'd': 1200})
            .map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
        startCooking: j['startCooking'] != false,
        mealTime: j['mealTime'] != false,
        prepNight: j['prepNight'] != false,
        shopping: j['shopping'] != false,
        shoppingWeekday: (j['shoppingWeekday'] as num?)?.toInt() ?? DateTime.thursday,
        shoppingTime: (j['shoppingTime'] as num?)?.toInt() ?? 18 * 60,
      );
}

String hhmm(int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  final h12 = h % 12 == 0 ? 12 : h % 12;
  final ampm = h < 12 ? tx('ص', 'AM') : tx('م', 'PM');
  return '$h12:${m.toString().padLeft(2, '0')} $ampm';
}

class Notifier {
  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ready = false;
  static const timerBase = 9000;
  static const shoppingId = 8000;

  static Future<void> init() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      _setLocalZone();
      await _p.initialize(const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher')));
      _ready = true;
    } catch (_) {
      // Reminders are optional; never block the app.
    }
  }

  static void _setLocalZone() {
    final offset = DateTime.now().timeZoneOffset;
    if (offset == const Duration(hours: 3)) {
      tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final loc in tz.timeZoneDatabase.locations.values) {
      if (loc.timeZone(now).offset == offset.inMilliseconds) {
        tz.setLocalLocation(loc);
        return;
      }
    }
  }

  static Future<bool> requestPermission() async {
    await init();
    final android = _p.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ok = await android?.requestNotificationsPermission() ?? true;
    try {
      await android?.requestExactAlarmsPermission();
    } catch (_) {}
    return ok;
  }

  static NotificationDetails _details(bool alarm) => NotificationDetails(
        android: alarm
            ? AndroidNotificationDetails(
                'sufra_timer', tx('مؤقت الطبخ', 'Cooking timer'),
                channelDescription:
                    tx('ينبهك لما يخلص وقت الطبخ', 'Alerts when cooking time is up'),
                importance: Importance.max,
                priority: Priority.max,
                category: AndroidNotificationCategory.alarm,
                playSound: true,
                enableVibration: true)
            : AndroidNotificationDetails(
                'sufra_meals', tx('تذكير الوجبات', 'Meal reminders'),
                channelDescription:
                    tx('متى تبدأ الطبخ ووقت الوجبة', 'When to start cooking and meal time'),
                importance: Importance.high,
                priority: Priority.high),
      );

  static Future<void> at(int id, DateTime when, String title, String body,
      {bool alarm = false, DateTimeComponents? repeat}) async {
    await init();
    if (!_ready) return;
    if (repeat == null && !when.isAfter(DateTime.now())) return;
    final t = tz.TZDateTime.from(when, tz.local);
    try {
      await _p.zonedSchedule(id, title, body, t, _details(alarm),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: repeat);
    } catch (_) {
      // Exact alarms not allowed: fall back to inexact.
      try {
        await _p.zonedSchedule(id, title, body, t, _details(alarm),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: repeat);
      } catch (_) {}
    }
  }

  static Future<void> cancel(int id) async {
    await init();
    if (_ready) await _p.cancel(id);
  }

  static Future<void> test() => at(
      7999,
      DateTime.now().add(const Duration(seconds: 5)),
      tx('🍽️ سفرة', '🍽️ Sufra'),
      tx('التنبيهات شغالة ✓', 'Reminders are working ✓'));

  /// Cooking timer that rings even if you leave the app.
  static Future<void> timer(int step, int minutes, String recipe) => at(
      timerBase + step,
      DateTime.now().add(Duration(minutes: minutes)),
      tx('⏰ الأكل على النار!', '⏰ Food on the stove!'),
      tx('خلص وقت الخطوة ${step + 1} في $recipe. روح شوفه قبل ما يحترق.',
          'Step ${step + 1} of $recipe is done. Check it before it burns.'),
      alarm: true);

  static Future<void> cancelTimer(int step) => cancel(timerBase + step);

  /// Rebuilds every plan reminder for the coming week.
  static Future<void> schedulePlan(AppState app) async {
    await init();
    if (!_ready) return;
    try {
      final pending = await _p.pendingNotificationRequests();
      for (final n in pending) {
        if (n.id < timerBase) await _p.cancel(n.id);
      }
    } catch (_) {}
    final s = app.notif;
    if (!s.enabled) return;

    for (var day = 0; day < 7; day++) {
      final prep = <String>[];
      for (final m in app.plan.where((m) => m.day == day)) {
        final r = app.c.recipeById[m.recipeId];
        if (r == null) continue;
        final at0 = app.mealTime(day, m.slot);
        final slot = slotNames[m.slot] ?? '';
        final base = 100 + day * 100 + slotOrder.indexOf(m.slot) * 10;
        if (s.startCooking) {
          if (m.leftover) {
            await at(base + 1, at0.subtract(const Duration(minutes: 10)),
                tx('🍱 سخّن $slot', '🍱 Reheat $slot'),
                tx('${r.title} من أمس. سخّنها كويس قبل الأكل.',
                    '${r.title} from yesterday. Reheat well before eating.'));
          } else {
            final start = at0.subtract(Duration(minutes: r.minutes + 10));
            await at(base + 1, start,
                tx('🍳 وقت تبدأ تطبخ $slot', '🍳 Time to start $slot'),
                tx('ابدأ ${r.title} الحين عشان يجهز ${hhmm(at0.hour * 60 + at0.minute)} (يحتاج ${r.minutes} دقيقة).',
                    'Start ${r.title} now so it is ready at ${hhmm(at0.hour * 60 + at0.minute)} (takes ${r.minutes} min).'));
          }
        }
        if (s.mealTime) {
          await at(base + 2, at0, tx('🍽️ وقت $slot', '🍽️ $slot time'),
              r.title);
        }
        if (s.prepNight && !m.leftover) {
          final text = r.steps.join(' ');
          if (text.contains('الليلة') || text.contains('انقع')) {
            prep.add(tx('انقع/جهّز مكونات ${r.titleAr}', 'Soak/prepare for ${r.title}'));
          }
          final meat = r.lines
              .map((l) => app.c.ingredients[l.ingId])
              .where((i) =>
                  i != null &&
                  (i.aisle == 'meat' || i.aisle == 'seafood') &&
                  !app.prefs.fridge.contains(i.id))
              .map((i) => i!.name)
              .toList();
          if (meat.isNotEmpty) {
            prep.add(tx('طلّع ${meat.join('، ')} من الفريزر للثلاجة',
                'Move ${meat.join(', ')} from freezer to fridge'));
          }
        }
      }
      if (prep.isNotEmpty) {
        final night = app.dayDate(day).subtract(const Duration(hours: 3));
        await at(50 + day, night, tx('🌙 جهّز لبكرة', '🌙 Prepare for tomorrow'),
            prep.join(' · '));
      }
    }

    if (s.shopping) {
      final now = DateTime.now();
      var d = DateTime(now.year, now.month, now.day)
          .add(Duration(minutes: s.shoppingTime));
      while (d.weekday != s.shoppingWeekday || !d.isAfter(now)) {
        d = d.add(const Duration(days: 1));
      }
      await at(shoppingId, d, tx('🛒 يوم المشتريات', '🛒 Shopping day'),
          tx('قائمة مشترياتك جاهزة في التطبيق.', 'Your shopping list is ready in the app.'),
          repeat: DateTimeComponents.dayOfWeekAndTime);
    }
  }
}
