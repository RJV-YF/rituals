import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/core/utils/date_labels.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/analytics_card.dart';

/// Square edge, and the gap around it. Wide enough to hold two digits.
const _square = 26.0;
const _gap = 4.0;
const _cell = _square + _gap;

/// Room above the grid for the month names.
const _headerHeight = 18.0;

/// A year of weeks, the most the rolling window can ever hold.
const _maxColumns = 53;

/// The rolling strip of days, one square each, greener the more was kept, with
/// the date of the day printed inside it.
///
/// The green says how much was kept and the position says when; nothing else
/// is drawn on a square. Today is not marked — it is the near end of the strip
/// and the last filled square in it, which is where the eye lands anyway.
///
/// The grid always fills the card. A reader on their second day gets the same
/// shape as a reader on their two hundredth — weeks they were not here for are
/// drawn faintly rather than left out, because a card with one square in it
/// reads as broken, not as new.
class HeatmapCard extends StatelessWidget {
  const HeatmapCard({
    super.key,
    required this.startDate,
    required this.today,
    required this.datasets,
    required this.onDayTapped,
    this.selectedDay,
  });

  /// The day the reader's history begins — the day they actually started, not
  /// the 1st of the month it fell in. Days before it are drawn, but muted.
  final DateTime startDate;

  /// The far end of the strip. The week it falls in is still running, so the
  /// days after it are drawn as outlines rather than left as a ragged edge.
  final DateTime today;

  /// Rituals kept per day. Days that are absent stay the empty colour.
  final Map<DateTime, int> datasets;

  final void Function(DateTime day) onDayTapped;

  /// The day the reader tapped, ringed so the card below it has an anchor.
  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: _headerHeight),
                child: _WeekdayLabels(),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // The strip always ends on the week in hand, and always
                    // reaches back far enough to fill the card.
                    final lastWeek = _addDays(today, -(today.weekday % 7));
                    final firstWeek = _addDays(
                      startDate,
                      -(startDate.weekday % 7),
                    );

                    final tracked = _daysBetween(firstWeek, lastWeek) ~/ 7 + 1;
                    final fits = (constraints.maxWidth / _cell).floor().clamp(
                      1,
                      _maxColumns,
                    );
                    final columns = tracked > fits ? tracked : fits;

                    final gridStart = _addDays(lastWeek, -(columns - 1) * 7);

                    // Anchored on today once there is more history than fits,
                    // because the near end is what anyone opening this page
                    // came for.
                    final overflows = columns > fits;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: overflows,
                      physics: overflows
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: columns * _cell,
                            height: _headerHeight,
                            child: _MonthLabels(
                              gridStart: gridStart,
                              columns: columns,
                              today: today,
                            ),
                          ),
                          Row(
                            children: [
                              for (var c = 0; c < columns; c++)
                                _WeekColumn(
                                  weekStart: _addDays(gridStart, c * 7),
                                  startDate: startDate,
                                  today: today,
                                  datasets: datasets,
                                  selectedDay: selectedDay,
                                  onDayTapped: onDayTapped,
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _Legend(),
        ],
      ),
    );
  }
}

/// One week, read top to bottom: Sunday through Saturday.
class _WeekColumn extends StatelessWidget {
  const _WeekColumn({
    required this.weekStart,
    required this.startDate,
    required this.today,
    required this.datasets,
    required this.selectedDay,
    required this.onDayTapped,
  });

  final DateTime weekStart;
  final DateTime startDate;
  final DateTime today;
  final Map<DateTime, int> datasets;
  final DateTime? selectedDay;
  final void Function(DateTime day) onDayTapped;

  @override
  Widget build(BuildContext context) {
    return Column(children: [for (var row = 0; row < 7; row++) _dayAt(row)]);
  }

  Widget _dayAt(int row) {
    final day = _addDays(weekStart, row);

    // The strip stops at today's week, so anything past today is the rest of
    // the week in hand: drawn empty-handed rather than not drawn at all, so
    // the current week reads as running and not as the end of the record.
    if (day.isAfter(today)) return _ComingDay(day: day);

    // Nothing was asked of the reader before they arrived, so these days hold
    // the grid's shape without claiming to be days they let slip.
    if (day.isBefore(startDate)) return _UntrackedDay(day: day);

    return _DaySquare(
      day: day,
      kept: datasets[day] ?? 0,
      isSelected: day == selectedDay,
      onTap: () => onDayTapped(day),
    );
  }
}

class _DaySquare extends StatelessWidget {
  const _DaySquare({
    required this.day,
    required this.kept,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime day;
  final int kept;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Ink on every square rather than white on the greens: this ramp tops out
    // at a mid green, which white sits on far too faintly to read.
    final textColor = kept > 0
        ? AppColors.ink
        : AppColors.ink.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: onTap,
      // The gap is kept as margin rather than as a larger box around the
      // square, so the tap still covers the whole cell.
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: _square,
        height: _square,
        margin: const EdgeInsets.all(_gap / 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kept == 0
              ? AppColors.heatmapEmpty
              : AppColors.heatmapScale[kept.clamp(1, 5)],
          borderRadius: BorderRadius.circular(7),
          // The only mark on a square, and only while the reader is holding
          // a day open below.
          border: isSelected
              ? Border.all(color: AppColors.ink, width: 1.6)
              : null,
        ),
        child: Text(
          '${day.day}',
          style: AppTypography.heatmapDay.copyWith(color: textColor),
        ),
      ),
    );
  }
}

/// A day from before the reader began: filled, so the grid keeps its shape,
/// but faded, so it is plainly not a day they were asked for anything.
class _UntrackedDay extends StatelessWidget {
  const _UntrackedDay({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _square,
      height: _square,
      margin: const EdgeInsets.all(_gap / 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.heatmapEmpty.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '${day.day}',
        style: AppTypography.heatmapDay.copyWith(
          color: AppColors.ink.withValues(alpha: 0.22),
        ),
      ),
    );
  }
}

/// A day in the week in hand that has not come round yet: named, but empty.
class _ComingDay extends StatelessWidget {
  const _ComingDay({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _square,
      height: _square,
      margin: const EdgeInsets.all(_gap / 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.heatmapEmpty, width: 1.2),
      ),
      child: Text(
        '${day.day}',
        style: AppTypography.heatmapDay.copyWith(
          color: AppColors.ink.withValues(alpha: 0.22),
        ),
      ),
    );
  }
}

/// Month names, each sitting over the first column that mostly belongs to it.
class _MonthLabels extends StatelessWidget {
  const _MonthLabels({
    required this.gridStart,
    required this.columns,
    required this.today,
  });

  final DateTime gridStart;
  final int columns;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final (column, month) in _labels())
          Positioned(
            left: column * _cell + _gap / 2,
            bottom: 2,
            child: Text(
              DateLabels.shortMonth(month),
              // The month being lived in is named in moss, so the far end of
              // the strip reads as the present rather than as an afterthought
              // to the month behind it.
              style: month.month == today.month && month.year == today.year
                  ? AppTypography.heatmapLabel.copyWith(color: AppColors.moss)
                  : AppTypography.heatmapLabel,
            ),
          ),
      ],
    );
  }

  /// Where each month is named: the first column that mostly falls in it.
  ///
  /// A column is judged by its Wednesday rather than its Sunday, so a week
  /// with two days of one month and five of the next is named for the five.
  /// The year is carried alongside the month, so a window long enough to hold
  /// the same month twice names it twice.
  List<(int, DateTime)> _labels() {
    final labels = <(int, DateTime)>[];
    DateTime? named;

    for (var column = 0; column < columns; column++) {
      final midweek = _addDays(gridStart, column * 7 + 3);
      if (named != null &&
          midweek.month == named.month &&
          midweek.year == named.year) {
        continue;
      }
      named = midweek;
      labels.add((column, midweek));
    }
    return labels;
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels();

  static const _labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final label in _labels)
          SizedBox(
            height: _cell,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(label, style: AppTypography.heatmapLabel),
              ),
            ),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Less',
          style: AppTypography.tag.copyWith(color: AppColors.inkMuted),
        ),
        const SizedBox(width: 6),
        const _Swatch(AppColors.heatmapEmpty),
        for (final color in AppColors.heatmapScale.values) _Swatch(color),
        const SizedBox(width: 6),
        Text(
          'More',
          style: AppTypography.tag.copyWith(color: AppColors.inkMuted),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

/// Days are stepped by calendar date rather than by 24 hours, so a
/// daylight-saving change can't shift a square onto the wrong day.
DateTime _addDays(DateTime day, int count) =>
    DateTime(day.year, day.month, day.day + count);

int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
