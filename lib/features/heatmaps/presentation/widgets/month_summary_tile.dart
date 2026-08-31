import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/core/utils/date_labels.dart';
import 'package:rituals/features/heatmaps/data/models/month_summary.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/analytics_card.dart';

/// One stored month, read back as a line of history.
class MonthSummaryTile extends StatelessWidget {
  const MonthSummaryTile({
    super.key,
    required this.summary,
    required this.today,
  });

  final MonthSummary summary;

  /// Today's date, so the current month can be named without its year and
  /// marked as still running.
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final isCurrent =
        summary.year == today.year && summary.month == today.month;
    final percent = (summary.completionRate * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnalyticsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateLabels.monthYear(summary.firstDay, relativeTo: today),
                    style: AppTypography.monthTitle,
                  ),
                ),
                Text(
                  summary.planned == 0 ? '—' : '$percent%',
                  style: AppTypography.monthTitle.copyWith(
                    color: AppColors.moss,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _CompletionBar(fraction: summary.completionRate),
            const SizedBox(height: 10),
            Text(
              _caption(summary, isCurrent: isCurrent),
              style: AppTypography.toggleSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  String _caption(MonthSummary summary, {required bool isCurrent}) {
    if (summary.planned == 0) {
      return isCurrent ? 'Nothing on the list yet' : 'No rituals this month';
    }

    final parts = [
      '${summary.kept} of ${summary.planned} kept',
      '${summary.activeDays} active ${summary.activeDays == 1 ? 'day' : 'days'}',
      if (summary.longestStreak > 1) 'best run ${summary.longestStreak}',
    ];
    return parts.join(' · ');
  }
}

class _CompletionBar extends StatelessWidget {
  const _CompletionBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: fraction.clamp(0, 1),
        minHeight: 7,
        backgroundColor: AppColors.heatmapEmpty,
        valueColor: const AlwaysStoppedAnimation(AppColors.moss),
      ),
    );
  }
}
