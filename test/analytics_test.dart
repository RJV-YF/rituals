import 'package:flutter_test/flutter_test.dart';
import 'package:rituals/features/heatmaps/data/models/month_summary.dart';
import 'package:rituals/features/heatmaps/presentation/cubit/heatmap_cubit.dart';
import 'package:rituals/features/heatmaps/presentation/cubit/heatmap_state.dart';

/// A month whose day counts are given as `day: kept of planned`.
MonthSummary _month(
  int year,
  int month, {
  Map<int, (int kept, int planned)> days = const {},
}) {
  final dayCount = DateTime(year, month + 1, 0).day;
  final keptByDay = List.filled(dayCount, 0);
  final plannedByDay = List.filled(dayCount, 0);

  for (final entry in days.entries) {
    keptByDay[entry.key - 1] = entry.value.$1;
    plannedByDay[entry.key - 1] = entry.value.$2;
  }

  return MonthSummary()
    ..id = monthKeyOf(DateTime(year, month))
    ..year = year
    ..month = month
    ..keptByDay = keptByDay
    ..plannedByDay = plannedByDay
    ..kept = keptByDay.fold(0, (sum, value) => sum + value)
    ..planned = plannedByDay.fold(0, (sum, value) => sum + value)
    ..activeDays = keptByDay.where((count) => count > 0).length
    ..trackedDays = plannedByDay.where((count) => count > 0).length
    ..longestStreak = 0
    ..updatedAt = DateTime(year, month)
    ..isSealed = false;
}

Map<DateTime, DaySummary> _days(Map<int, (int kept, int planned)> byDay) {
  return {
    for (final entry in byDay.entries)
      DateTime(2026, 8, entry.key): DaySummary(
        day: DateTime(2026, 8, entry.key),
        kept: entry.value.$1,
        planned: entry.value.$2,
      ),
  };
}

void main() {
  group('MonthSummary', () {
    test('reports the busiest day of the month', () {
      final august = _month(2026, 8, days: {3: (1, 2), 11: (4, 4), 19: (2, 3)});

      expect(august.bestDayKept, 4);
      expect(august.bestDay, DateTime(2026, 8, 11));
    });

    test('has no best day when nothing was kept', () {
      final august = _month(2026, 8, days: {3: (0, 2)});

      expect(august.bestDay, isNull);
      expect(august.completionRate, 0);
    });

    test('rates a month it has no tasks for at zero rather than dividing', () {
      expect(_month(2026, 8).completionRate, 0);
    });
  });

  group('DaySummary.fromMonths', () {
    test('unpacks only the days that had something on the list', () {
      final days = DaySummary.fromMonths(
        [
          _month(2026, 8, days: {1: (2, 3), 2: (0, 1)}),
        ],
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 8, 31),
      );

      expect(days.keys, [DateTime(2026, 8, 1), DateTime(2026, 8, 2)]);
      expect(days[DateTime(2026, 8, 1)]!.kept, 2);
      expect(days[DateTime(2026, 8, 1)]!.planned, 3);
    });

    test('drops days outside the visible range', () {
      final days = DaySummary.fromMonths(
        [
          _month(2026, 8, days: {1: (1, 1), 20: (1, 1), 31: (1, 1)}),
        ],
        start: DateTime(2026, 8, 10),
        end: DateTime(2026, 8, 25),
      );

      expect(days.keys, [DateTime(2026, 8, 20)]);
    });
  });

  group('HeatmapStats.from', () {
    test('adds up what was kept and what was on the list', () {
      final stats = HeatmapStats.from(
        _days({1: (2, 3), 2: (0, 2), 3: (1, 1)}),
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 3),
      );

      expect(stats.kept, 3);
      expect(stats.planned, 6);
      expect(stats.activeDays, 2);
      expect(stats.trackedDays, 3);
      expect(stats.completionRate, 0.5);
      expect(stats.bestDay, DateTime(2026, 8, 1));
      expect(stats.bestDayKept, 2);
    });

    test('counts the run up to today', () {
      final stats = HeatmapStats.from(
        _days({1: (1, 1), 3: (1, 1), 4: (1, 1), 5: (1, 1)}),
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 5),
      );

      expect(stats.currentStreak, 3);
    });

    test('keeps the streak alive on a today nothing has been kept on yet', () {
      final stats = HeatmapStats.from(
        _days({3: (1, 1), 4: (1, 1), 5: (0, 2)}),
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 5),
      );

      expect(stats.currentStreak, 2);
    });

    test('breaks the streak on a missed yesterday', () {
      final stats = HeatmapStats.from(
        _days({3: (1, 1), 4: (0, 1), 5: (0, 1)}),
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 5),
      );

      expect(stats.currentStreak, 0);
    });

    test('finds the longest run even when it is not the current one', () {
      final stats = HeatmapStats.from(
        _days({
          1: (1, 1),
          2: (1, 1),
          3: (1, 1),
          4: (1, 1),
          6: (0, 1),
          7: (1, 1),
        }),
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 7),
      );

      expect(stats.longestStreak, 4);
      expect(stats.currentStreak, 1);
    });

    test('is all zeroes when nothing has been tracked', () {
      final stats = HeatmapStats.from(
        const {},
        start: DateTime(2026, 8, 1),
        today: DateTime(2026, 8, 31),
      );

      expect(stats.kept, 0);
      expect(stats.currentStreak, 0);
      expect(stats.bestDay, isNull);
      expect(stats.completionRate, 0);
    });
  });

  group('HeatmapCubit.startOfRange', () {
    test('starts at the month the user began in', () {
      final start = HeatmapCubit.startOfRange(
        firstTracked: DateTime(2026, 5, 17),
        today: DateTime(2026, 8, 31),
      );

      expect(start, DateTime(2026, 5, 1));
    });

    test('reaches back no further than a year', () {
      final start = HeatmapCubit.startOfRange(
        firstTracked: DateTime(2021, 3, 4),
        today: DateTime(2026, 8, 31),
      );

      expect(start, DateTime(2025, 9, 1));
    });

    test('crosses the new year cleanly', () {
      final start = HeatmapCubit.startOfRange(
        firstTracked: DateTime(2024, 1, 1),
        today: DateTime(2026, 2, 10),
      );

      expect(start, DateTime(2025, 3, 1));
    });
  });
}
