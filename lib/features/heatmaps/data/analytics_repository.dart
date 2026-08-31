import 'package:isar_community/isar.dart';
import 'package:rituals/core/database/app_database.dart';
import 'package:rituals/features/heatmaps/data/models/month_summary.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

/// Reads the task history back as month-sized analytics.
///
/// Nothing here writes tasks — it only folds what the tasks feature has
/// already recorded into [MonthSummary] rows and hands them out.
class AnalyticsRepository {
  AnalyticsRepository(AppDatabase database) : _isar = database.isar;

  final Isar _isar;

  /// Local midnight of the first day anything was ever tracked, or null when
  /// the task list has never had anything in it.
  ///
  /// Walks the date index, so it reads one row rather than the whole history.
  Future<DateTime?> firstTrackedDay() async {
    final earliest = await _isar.tasks.where().anyDate().findFirst();
    return earliest == null ? null : dayOf(earliest.date);
  }

  /// Summaries for every month from the one containing [from] up to the one
  /// containing [to], oldest first.
  Future<List<MonthSummary>> summariesBetween({
    required DateTime from,
    required DateTime to,
  }) async {
    final summaries = <MonthSummary>[];
    var month = DateTime(from.year, from.month);
    final last = DateTime(to.year, to.month);

    while (!month.isAfter(last)) {
      summaries.add(await summaryFor(month));
      month = DateTime(month.year, month.month + 1);
    }
    return summaries;
  }

  /// The summary for [month], rebuilt from the task rows unless a sealed one
  /// is already stored.
  Future<MonthSummary> summaryFor(DateTime month) async {
    final stored = await _isar.monthSummarys.get(monthKeyOf(month));
    if (stored != null && stored.isSealed) return stored;

    final summary = await _build(month);
    await _isar.writeTxn(() => _isar.monthSummarys.put(summary));
    return summary;
  }

  /// Every summary held on record, newest month first.
  ///
  /// The heatmap doesn't need this — it exists so later analytics can ask the
  /// database for the history directly instead of re-reading tasks.
  Future<List<MonthSummary>> storedSummaries() {
    return _isar.monthSummarys
        .where()
        .sortByYearDesc()
        .thenByMonthDesc()
        .findAll();
  }

  /// Drops every stored summary, so the next read rebuilds from tasks.
  ///
  /// Sealed months are otherwise never revisited, which is the point of them —
  /// this is the way back if history is edited underneath us.
  Future<void> clearSummaries() {
    return _isar.writeTxn(() => _isar.monthSummarys.clear());
  }

  Future<MonthSummary> _build(DateTime month) async {
    final first = DateTime(month.year, month.month);
    // Day zero of the next month is the last day of this one.
    final last = DateTime(month.year, month.month + 1, 0);
    final dayCount = last.day;

    final tasks = await _isar.tasks.filter().dateBetween(first, last).findAll();

    final keptByDay = List.filled(dayCount, 0);
    final plannedByDay = List.filled(dayCount, 0);
    for (final task in tasks) {
      final index = task.date.day - 1;
      plannedByDay[index]++;
      if (task.isCompleted) keptByDay[index]++;
    }

    var kept = 0;
    var planned = 0;
    var activeDays = 0;
    var trackedDays = 0;
    var longestStreak = 0;
    var run = 0;

    for (var day = 0; day < dayCount; day++) {
      kept += keptByDay[day];
      planned += plannedByDay[day];
      if (plannedByDay[day] > 0) trackedDays++;

      if (keptByDay[day] > 0) {
        activeDays++;
        run++;
        if (run > longestStreak) longestStreak = run;
      } else {
        run = 0;
      }
    }

    return MonthSummary()
      ..id = monthKeyOf(month)
      ..year = month.year
      ..month = month.month
      ..keptByDay = keptByDay
      ..plannedByDay = plannedByDay
      ..kept = kept
      ..planned = planned
      ..activeDays = activeDays
      ..trackedDays = trackedDays
      ..longestStreak = longestStreak
      ..updatedAt = DateTime.now()
      // Only a month that has fully passed is safe to seal.
      ..isSealed = last.isBefore(dayOf(DateTime.now()));
  }
}
