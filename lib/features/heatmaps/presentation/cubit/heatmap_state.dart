import 'package:rituals/features/heatmaps/data/models/month_summary.dart';

/// State of the consistency view.
///
/// As with the task states, these intentionally do not override `==`:
/// [MonthSummary] is a mutable Isar object with identity equality, so a
/// value-based comparison would be unreliable and a state wrongly judged equal
/// is one bloc drops.
sealed class HeatmapState {
  const HeatmapState();
}

class HeatmapLoading extends HeatmapState {
  const HeatmapLoading();
}

/// Nothing has ever been tracked, so there is no grid to draw yet.
class HeatmapEmpty extends HeatmapState {
  const HeatmapEmpty();
}

class HeatmapFailure extends HeatmapState {
  const HeatmapFailure(this.message);

  final String message;
}

class HeatmapReady extends HeatmapState {
  const HeatmapReady({
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.datasets,
    required this.months,
    required this.stats,
    this.selectedDay,
  });

  /// First day of the grid — always the 1st of a month, so the month labels
  /// along the top line up with the columns beneath them.
  final DateTime startDate;

  /// Last day of the grid, which is today.
  final DateTime endDate;

  /// Every day in range that had anything on the list, keyed by local midnight.
  final Map<DateTime, DaySummary> days;

  /// What the grid itself is drawn from: kept counts for the days that had at
  /// least one, which is the shape `HeatMap` wants.
  final Map<DateTime, int> datasets;

  /// Months covered by the grid, newest first.
  final List<MonthSummary> months;

  final HeatmapStats stats;

  /// The day the reader tapped, if any.
  final DaySummary? selectedDay;

  HeatmapReady select(DaySummary? day) {
    return HeatmapReady(
      startDate: startDate,
      endDate: endDate,
      days: days,
      datasets: datasets,
      months: months,
      stats: stats,
      selectedDay: day,
    );
  }
}

/// One day's numbers, as read back out of the month summaries.
class DaySummary {
  const DaySummary({
    required this.day,
    required this.kept,
    required this.planned,
  });

  /// Unpacks the per-day counts the summaries were built from, keeping only
  /// the days inside [start]..[end] that had something on the list.
  static Map<DateTime, DaySummary> fromMonths(
    List<MonthSummary> months, {
    required DateTime start,
    required DateTime end,
  }) {
    final days = <DateTime, DaySummary>{};

    for (final month in months) {
      for (var index = 0; index < month.plannedByDay.length; index++) {
        if (month.plannedByDay[index] == 0) continue;

        final day = DateTime(month.year, month.month, index + 1);
        if (day.isBefore(start) || day.isAfter(end)) continue;

        days[day] = DaySummary(
          day: day,
          kept: month.keptByDay[index],
          planned: month.plannedByDay[index],
        );
      }
    }
    return days;
  }

  final DateTime day;
  final int kept;
  final int planned;

  bool get isComplete => planned > 0 && kept == planned;
}

/// Totals across the whole visible range.
class HeatmapStats {
  const HeatmapStats({
    required this.kept,
    required this.planned,
    required this.activeDays,
    required this.trackedDays,
    required this.currentStreak,
    required this.longestStreak,
    required this.bestDay,
    required this.bestDayKept,
  });

  static const empty = HeatmapStats(
    kept: 0,
    planned: 0,
    activeDays: 0,
    trackedDays: 0,
    currentStreak: 0,
    longestStreak: 0,
    bestDay: null,
    bestDayKept: 0,
  );

  /// Folds the visible days down into the numbers shown above the month list.
  factory HeatmapStats.from(
    Map<DateTime, DaySummary> days, {
    required DateTime start,
    required DateTime today,
  }) {
    if (days.isEmpty) return empty;

    var kept = 0;
    var planned = 0;
    var activeDays = 0;
    var bestDayKept = 0;
    DateTime? bestDay;

    for (final day in days.values) {
      kept += day.kept;
      planned += day.planned;
      if (day.kept > 0) activeDays++;
      if (day.kept > bestDayKept) {
        bestDayKept = day.kept;
        bestDay = day.day;
      }
    }

    return HeatmapStats(
      kept: kept,
      planned: planned,
      activeDays: activeDays,
      trackedDays: days.length,
      currentStreak: _currentStreak(days, today),
      longestStreak: _longestStreak(days, start: start, end: today),
      bestDay: bestDay,
      bestDayKept: bestDayKept,
    );
  }

  final int kept;
  final int planned;

  /// Days something was kept on.
  final int activeDays;

  /// Days something was on the list at all.
  final int trackedDays;

  /// Days kept in a row up to now.
  final int currentStreak;

  /// The longest such run anywhere in range.
  final int longestStreak;

  final DateTime? bestDay;
  final int bestDayKept;

  double get completionRate => planned == 0 ? 0 : kept / planned;

  /// Days kept in a row, counting back from today.
  ///
  /// Today is skipped rather than breaking the run when nothing has been kept
  /// on it yet — the day isn't over, and a streak that resets at every midnight
  /// would be telling the reader off for getting up.
  static int _currentStreak(Map<DateTime, DaySummary> days, DateTime today) {
    var cursor = today;
    if ((days[today]?.kept ?? 0) == 0) cursor = _previousDay(today);

    var streak = 0;
    while ((days[cursor]?.kept ?? 0) > 0) {
      streak++;
      cursor = _previousDay(cursor);
    }
    return streak;
  }

  static int _longestStreak(
    Map<DateTime, DaySummary> days, {
    required DateTime start,
    required DateTime end,
  }) {
    var longest = 0;
    var run = 0;

    for (var day = start; !day.isAfter(end); day = _nextDay(day)) {
      if ((days[day]?.kept ?? 0) > 0) {
        run++;
        if (run > longest) longest = run;
      } else {
        run = 0;
      }
    }
    return longest;
  }

  /// Days are stepped by calendar date rather than by 24 hours, so a
  /// daylight-saving change can't shift the cursor off local midnight.
  static DateTime _nextDay(DateTime day) =>
      DateTime(day.year, day.month, day.day + 1);

  static DateTime _previousDay(DateTime day) =>
      DateTime(day.year, day.month, day.day - 1);
}
