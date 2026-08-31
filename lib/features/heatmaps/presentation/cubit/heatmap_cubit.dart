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
  static const maxMonths = 12;

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

  /// Where the grid begins: the 1st of the month the user actually started in,
  /// so it never opens on a run of empty squares from before they began — and
  /// never further back than [maxMonths].
  ///
  /// Starting on a month boundary is also what keeps the month labels above
  /// the grid sitting over the columns they belong to.
  static DateTime startOfRange({
    required DateTime firstTracked,
    required DateTime today,
  }) {
    final began = DateTime(firstTracked.year, firstTracked.month);
    final limit = DateTime(today.year, today.month - (maxMonths - 1));
    return began.isAfter(limit) ? began : limit;
  }
}
