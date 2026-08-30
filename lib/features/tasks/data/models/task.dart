import 'package:isar_community/isar.dart';

part 'task.g.dart';

/// One task on one day.
///
/// A repeating task is stored as a fresh row per day rather than a single
/// recurring record, so completing today never rewrites yesterday's history.
/// [seriesId] is what ties those daily copies together — the rollover uses it
/// to tell "already carried forward" from "needs carrying forward".
@collection
class Task {
  Id id = Isar.autoIncrement;

  /// Shared by every daily copy of the same repeating task. Set to the row's
  /// own [id] when the task is first created.
  @Index()
  late int seriesId;

  late String title;

  String? note;

  bool isCompleted = false;

  bool isRepeating = false;

  bool hasAlarm = false;

  /// Minutes since local midnight, e.g. 435 for 07:15. Null when [hasAlarm]
  /// is false. Stored as an offset rather than a [DateTime] because the alarm
  /// is a time of day that recurs, not a single instant.
  int? alarmMinutes;

  /// Local midnight of the day this task belongs to.
  @Index()
  late DateTime date;

  late DateTime createdAt;

  @ignore
  int get alarmHour => (alarmMinutes ?? 0) ~/ 60;

  @ignore
  int get alarmMinute => (alarmMinutes ?? 0) % 60;

  Task copyForDay(DateTime day) {
    return Task()
      ..seriesId = seriesId
      ..title = title
      ..note = note
      ..isCompleted = false
      ..isRepeating = isRepeating
      ..hasAlarm = hasAlarm
      ..alarmMinutes = alarmMinutes
      ..date = day
      ..createdAt = DateTime.now();
  }
}

/// Strips the time component, giving local midnight of [value]'s day.
DateTime dayOf(DateTime value) => DateTime(value.year, value.month, value.day);
