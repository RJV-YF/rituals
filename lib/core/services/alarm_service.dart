import 'package:flutter/services.dart';

/// Result of handing an alarm off to the device clock app.
enum AlarmResult {
  /// The clock app accepted the alarm.
  set,

  /// No installed app can handle the set-alarm intent.
  noClockApp,

  /// The platform rejected the request.
  failed,
}

/// Sets alarms in the device's own clock app via `AlarmClock.ACTION_SET_ALARM`.
///
/// Deliberately fire-and-forget: Android lets an app *create* a clock alarm but
/// gives no way to find or remove one it created later, so Rituals never claims
/// to own the alarm after handing it over. Turning an alarm off on a task stops
/// future ones — it cannot retract an alarm already in the clock app.
class AlarmService {
  const AlarmService();

  static const _channel = MethodChannel('com.example.rituals/alarm');

  /// Sets an alarm for [hour]:[minute], labelled [label].
  ///
  /// When [daily] is true the alarm is registered to repeat every day of the
  /// week, matching a repeating task; otherwise it fires at the next
  /// occurrence of that time and does not repeat.
  Future<AlarmResult> setAlarm({
    required int hour,
    required int minute,
    required String label,
    required bool daily,
  }) async {
    try {
      final handled = await _channel.invokeMethod<bool>('setAlarm', {
        'hour': hour,
        'minute': minute,
        'label': label,
        'daily': daily,
      });
      return (handled ?? false) ? AlarmResult.set : AlarmResult.noClockApp;
    } on PlatformException {
      return AlarmResult.failed;
    } on MissingPluginException {
      return AlarmResult.failed;
    }
  }
}
