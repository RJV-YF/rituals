import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rituals/features/heatmaps/data/analytics_repository.dart';
import 'package:rituals/features/heatmaps/presentation/cubit/heatmap_state.dart';
import 'package:rituals/features/tasks/data/models/task.dart';

class HeatmapCubit extends Cubit<HeatmapState> {
  HeatmapCubit({required AnalyticsRepository repository})
    : _repo = repository,
      super(const HeatmapLoading());

  final AnalyticsRepository _repo;

  /// How far back the grid is allowed to reach.
  ///
  /// A year is as much as reads at a glance; past that the strip is mostly
  /// scrolling over squares nobody is looking at.
  static const maxDays = 365;

  Future<void> load() async {
    emit(const HeatmapLoading());
    try {
      final firstTracked = await _repo.firstTrackedDay();
      if (firstTracked == null) {
        if (!isClosed) emit(const HeatmapEmpty());
        return;
      }

      final today = dayOf(DateTime.now());
      final start = startOfRange(firstTracked: firstTracked, today: today);
      final months = await _repo.summariesBetween(from: start, to: today);
      if (isClosed) return;

      final days = DaySummary.fromMonths(months, start: start, end: today);
      emit(
        HeatmapReady(
          startDate: start,
          endDate: today,
          days: days,
          datasets: {
            for (final day in days.values)
              if (day.kept > 0) day.day: day.kept,
          },
          months: months.reversed.toList(),
          stats: HeatmapStats.from(days, start: start, today: today),
        ),
      );
    } catch (_) {
      if (!isClosed) emit(const HeatmapFailure('Could not read your history.'));
    }
  }

  /// Shows what one day held, or clears the selection when that day is tapped
  /// again or has nothing on it.
  void selectDay(DateTime day) {
    if (state case final HeatmapReady ready) {
      final selected = ready.days[dayOf(day)];
      final isSame = ready.selectedDay?.day == selected?.day;
      emit(ready.select(isSame ? null : selected));
    }
  }

  void clearSelection() {
    if (state case final HeatmapReady ready) emit(ready.select(null));
  }

  /// Where the grid begins: the day the user actually started, and never
  /// further back than [maxDays].
  ///
  /// The window rolls by the day rather than by the month. Anchoring it to the
  /// 1st of the month someone began in would open their history on a run of
  /// squares from before they were here, and would keep that month at the head
  /// of the strip long after it stopped being the month they are living in.
  static DateTime startOfRange({
    required DateTime firstTracked,
    required DateTime today,
  }) {
    final began = dayOf(firstTracked);
    final limit = DateTime(today.year, today.month, today.day - maxDays + 1);
    return began.isAfter(limit) ? began : limit;
  }
}
