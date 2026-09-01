import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/core/theme/app_typography.dart';
import 'package:rituals/core/utils/date_labels.dart';
import 'package:rituals/features/heatmaps/data/analytics_repository.dart';
import 'package:rituals/features/heatmaps/presentation/cubit/heatmap_cubit.dart';
import 'package:rituals/features/heatmaps/presentation/cubit/heatmap_state.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/analytics_card.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/heatmap_card.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/month_summary_tile.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/stat_card.dart';

/// The year in squares: how much was kept, and when.
class HeatmapPage extends StatelessWidget {
  const HeatmapPage({super.key});

  /// Builds the page with its own cubit, so callers only have to push a route.
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) =>
            HeatmapCubit(repository: context.read<AnalyticsRepository>())
              ..load(),
        child: const HeatmapPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.parchment,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_left, color: AppColors.ink),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<HeatmapCubit, HeatmapState>(
          builder: (context, state) => switch (state) {
            HeatmapLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.moss),
            ),
            HeatmapFailure(:final message) => _Notice(title: message),
            HeatmapEmpty() => const _Notice(
              title: 'Nothing to look back on yet.',
              detail:
                  'Keep a ritual today and it shows up here as your first square.',
            ),
            HeatmapReady() => _Ready(state: state),
          },
        ),
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final HeatmapReady state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      children: [
        _Header(state: state),
        const SizedBox(height: 20),

        HeatmapCard(
          startDate: state.startDate,
          today: state.endDate,
          datasets: state.datasets,
          selectedDay: state.selectedDay?.day,
          onDayTapped: context.read<HeatmapCubit>().selectDay,
        ),
        const SizedBox(height: 12),
        _SelectedDay(day: state.selectedDay),

        const SizedBox(height: 24),
        const _SectionTitle('At a glance'),
        const SizedBox(height: 12),
        _StatGrid(stats: state.stats),

        const SizedBox(height: 28),
        const _SectionTitle('Month by month'),
        const SizedBox(height: 12),
        for (final summary in state.months)
          MonthSummaryTile(summary: summary, today: state.endDate),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final HeatmapReady state;

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final since = DateLabels.dayMonthYear(state.startDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SINCE ${since.toUpperCase()}', style: AppTypography.eyebrow),
        const SizedBox(height: 6),
        const Text('Consistency', style: AppTypography.pageTitle),
        const SizedBox(height: 4),
        Text(
          stats.kept == 0
              ? 'Nothing kept in this stretch yet'
              : '${stats.kept} kept across ${stats.activeDays} '
                    '${stats.activeDays == 1 ? 'day' : 'days'}',
          style: AppTypography.subtitle,
        ),
      ],
    );
  }
}

/// What one tapped square held — or the invitation to tap one.
class _SelectedDay extends StatelessWidget {
  const _SelectedDay({required this.day});

  final DaySummary? day;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: switch (day) {
        null => SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Tap a square to see that day.',
              style: AppTypography.toggleSubtitle,
            ),
          ),
        ),
        final day => _DayCard(day: day),
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});

  final DaySummary day;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: day.kept == 0
                  ? AppColors.heatmapEmpty
                  : AppColors.heatmapScale[day.kept.clamp(1, 5)],
              borderRadius: BorderRadius.circular(9),
            ),
            child: day.isComplete
                ? const Icon(
                    CupertinoIcons.check_mark,
                    size: 17,
                    color: Colors.white,
                  )
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateLabels.dayLine(day.day),
                  style: AppTypography.monthTitle,
                ),
                const SizedBox(height: 3),
                Text(
                  '${day.kept} of ${day.planned} kept',
                  style: AppTypography.toggleSubtitle,
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(
              CupertinoIcons.xmark,
              size: 16,
              color: AppColors.inkMuted,
            ),
            tooltip: 'Clear',
            onPressed: context.read<HeatmapCubit>().clearSelection,
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final HeatmapStats stats;

  @override
  Widget build(BuildContext context) {
    final bestDay = stats.bestDay;

    return Column(
      children: [
        _StatRow(
          left: StatCard(
            value: '${stats.currentStreak}',
            label: stats.currentStreak == 1 ? 'Day running' : 'Days running',
            caption: stats.longestStreak == 0
                ? 'No runs yet'
                : 'Longest ${stats.longestStreak}',
          ),
          right: StatCard(
            value: '${(stats.completionRate * 100).round()}%',
            label: 'Kept overall',
            caption: '${stats.kept} of ${stats.planned}',
          ),
        ),
        const SizedBox(height: 10),
        _StatRow(
          left: StatCard(
            value: '${stats.activeDays}',
            label: 'Active days',
            caption: 'of ${stats.trackedDays} tracked',
          ),
          right: StatCard(
            value: '${stats.bestDayKept}',
            label: 'Best day',
            caption: bestDay == null
                ? 'Nothing kept yet'
                : DateLabels.dayAndMonth(bestDay),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 10),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title.toUpperCase(), style: AppTypography.eyebrow);
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.title, this.detail});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.emptyMessage,
          ),
          if (detail case final detail?) ...[
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: AppTypography.subtitle,
            ),
          ],
        ],
      ),
    );
  }
}
