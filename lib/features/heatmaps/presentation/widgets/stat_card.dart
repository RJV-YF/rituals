import 'package:flutter/material.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/analytics_card.dart';

/// One number worth knowing, with a word for what it counts.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.caption,
  });

  final String value;
  final String label;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.statValue),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.statLabel),
          if (caption case final caption?) ...[
            const SizedBox(height: 6),
            Text(
              caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.toggleSubtitle,
            ),
          ],
        ],
      ),
    );
  }
}
