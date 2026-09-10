/// The values collected by the task form.
///
/// Deliberately not a [Task]: the form gathers what the user typed, and the
/// cubit decides whether that becomes an insert or an update.
class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.note,
    required this.isRepeating,
    required this.repeatDays,
    required this.hasAlarm,
    required this.alarmMinutes,
  });

  final String title;
  final String? note;
  final bool isRepeating;

  /// ISO weekdays picked for the repeat, sorted. Empty when [isRepeating] is
  /// false.
  final List<int> repeatDays;

  final bool hasAlarm;

  /// Minutes since local midnight, or null when [hasAlarm] is false.
  final int? alarmMinutes;
}
