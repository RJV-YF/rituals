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
      );

      final today = yesterday.copyForDay(DateTime(2026, 8, 31));

      expect(today.title, 'Morning Run');
      expect(today.note, 'Along the river');
      expect(today.isRepeating, isTrue);
      expect(today.hasAlarm, isTrue);
      expect(today.alarmMinutes, 435);
      expect(today.alarmHour, 7);
      expect(today.alarmMinute, 15);
    });
  });
}
