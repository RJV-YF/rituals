import 'package:isar_community/isar.dart';

part 'month_summary.g.dart';

/// What one calendar month of rituals came to.
///
/// The heatmap needs a count for every day and the month summaries under it
/// need totals. Reading that off the task rows means walking a year of tasks on
/// every open, so a month is folded down once into this row instead: the
/// per-day counts the grid is drawn from, plus the totals worth querying on
/// later.
///
/// A month that has ended can never change, so its summary is [isSealed] after
/// the first build and read straight back from here from then on. The current
/// month is rebuilt on every open.
@collection
class MonthSummary {
  /// `year * 100 + month` — 202608 for August 2026.
  ///
  /// Used as the row's own id, so a month can only ever have one summary and
  /// rebuilding it is a plain put rather than a lookup-then-update.
  Id id = 0;

  late int year;

  /// 1 for January.
  late int month;

  /// Rituals kept on each day, index 0 being the 1st of the month.
  late List<int> keptByDay;

  /// Rituals that were on the list each day, kept or not.
  late List<int> plannedByDay;

  /// Sum of [keptByDay]. Stored rather than derived so months can be ranked
  /// and filtered by the database itself.
  late int kept;

  /// Sum of [plannedByDay].
  late int planned;

  /// Days with at least one ritual kept.
  late int activeDays;

  /// Days with at least one ritual on the list.
  late int trackedDays;

  /// Longest run of consecutive active days *within* this month.
  ///
  /// Deliberately month-local: a run that crosses into the next month can't be
  /// known from one row, so the cross-month figure is worked out from the
  /// stitched day counts instead.
  late int longestStreak;

  late DateTime updatedAt;

  /// Set once the month is over and nothing can change the numbers.
  bool isSealed = false;

  @ignore
  DateTime get firstDay => DateTime(year, month);

  @ignore
  double get completionRate => planned == 0 ? 0 : kept / planned;

  /// Most rituals kept on any single day of the month.
  @ignore
  int get bestDayKept =>
      keptByDay.fold(0, (best, count) => count > best ? count : best);

  /// The day that [bestDayKept] belongs to, or null if nothing was kept.
  @ignore
  DateTime? get bestDay {
    final best = bestDayKept;
    if (best == 0) return null;
    return DateTime(year, month, keptByDay.indexOf(best) + 1);
  }
}

/// The [MonthSummary.id] for the month [value] falls in.
int monthKeyOf(DateTime value) => value.year * 100 + value.month;
