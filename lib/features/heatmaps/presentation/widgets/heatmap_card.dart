import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/analytics_card.dart';

/// The contribution grid: one square per day, greener the more was kept.
class HeatmapCard extends StatelessWidget {
  const HeatmapCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.datasets,
    required this.onDayTapped,
  });

  final DateTime startDate;
  final DateTime endDate;

  /// Rituals kept per day. Days that are absent stay the empty colour.
  final Map<DateTime, int> datasets;

  final void Function(DateTime day) onDayTapped;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeatMap(
            startDate: startDate,
            endDate: endDate,
            datasets: datasets,
            // Thresholds, not opacity: a day with five rituals kept should
            // read the same shade whatever the busiest day of the range was.
            colorMode: ColorMode.color,
            colorsets: AppColors.heatmapScale,
            defaultColor: AppColors.heatmapEmpty,
            textColor: AppColors.inkMuted,
            size: 17,
            fontSize: 10,
            margin: const EdgeInsets.all(2.5),
            borderRadius: 5,
            showText: false,
            // Drawn below instead, so the legend matches the app's type.
            showColorTip: false,
            scrollable: true,
            onClick: onDayTapped,
          ),
          const SizedBox(height: 14),
          const _Legend(),
        ],
      ),
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
