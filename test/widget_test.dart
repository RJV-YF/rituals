import 'package:flutter_test/flutter_test.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

Task _task({
  required int seriesId,
  bool isCompleted = false,
  bool isRepeating = true,
  bool hasAlarm = false,
  int? alarmMinutes,
}) {
  return Task()
    ..seriesId = seriesId
    ..title = 'Morning Run'
    ..note = 'Along the river'
    ..isCompleted = isCompleted
    ..isRepeating = isRepeating
    ..hasAlarm = hasAlarm
    ..alarmMinutes = alarmMinutes
    ..date = DateTime(2026, 8, 30)
    ..createdAt = DateTime(2026, 8, 30, 6, 30);
}

void main() {
  group('dayOf', () {
    test('strips the time so any two instants on a day match', () {
      final morning = dayOf(DateTime(2026, 8, 31, 6, 30));
      final night = dayOf(DateTime(2026, 8, 31, 23, 59, 59));

      expect(morning, DateTime(2026, 8, 31));
      expect(morning, night);
    });
  });

  group('Task.copyForDay', () {
    test('carries the task forward uncompleted', () {
      final yesterday = _task(seriesId: 7, isCompleted: true);

      final today = yesterday.copyForDay(DateTime(2026, 8, 31));

      expect(today.isCompleted, isFalse);
      expect(today.date, DateTime(2026, 8, 31));
    });

    test('keeps the series so the rollover cannot duplicate it', () {
      final yesterday = _task(seriesId: 7);

      expect(yesterday.copyForDay(DateTime(2026, 8, 31)).seriesId, 7);
    });

    test('preserves title, note, repeat and alarm settings', () {
      final yesterday = _task(
        seriesId: 7,
        hasAlarm: true,
        alarmMinutes: 435,
      )..repeatDays = [1, 3, 5];

      final today = yesterday.copyForDay(DateTime(2026, 8, 31));

      expect(today.title, 'Morning Run');
      expect(today.note, 'Along the river');
      expect(today.isRepeating, isTrue);
      expect(today.repeatDays, [1, 3, 5]);
      expect(today.hasAlarm, isTrue);
      expect(today.alarmMinutes, 435);
      expect(today.alarmHour, 7);
      expect(today.alarmMinute, 15);
    });

    test('does not share the day list with the copy it came from', () {
      final yesterday = _task(seriesId: 7)..repeatDays = [1, 3, 5];

      final today = yesterday.copyForDay(DateTime(2026, 8, 31));
      today.repeatDays.add(7);

      expect(yesterday.repeatDays, [1, 3, 5]);
    });
  });

  group('Task.repeatsOn', () {
    // 31 August 2026 is a Monday, 1 September a Tuesday.
    final monday = DateTime(2026, 8, 31);
    final tuesday = DateTime(2026, 9, 1);

    test('only comes back on the picked weekdays', () {
      final task = _task(seriesId: 7)..repeatDays = [1, 3, 5];

      expect(task.repeatsOn(monday), isTrue);
      expect(task.repeatsOn(tuesday), isFalse);
    });

    test('reads a task saved before days existed as every day', () {
      final task = _task(seriesId: 7);

      expect(task.scheduledDays, allWeekdays);
      expect(task.repeatsOn(tuesday), isTrue);
    });

    test('never comes back once repeat is off, whatever the days say', () {
      final task = _task(seriesId: 7, isRepeating: false)
        ..repeatDays = [1, 2, 3, 4, 5, 6, 7];

      expect(task.repeatsOn(monday), isFalse);
    });
  });
}
