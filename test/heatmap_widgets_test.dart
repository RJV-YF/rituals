import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rituals/core/theme/app_colors.dart';
import 'package:rituals/features/heatmaps/data/models/month_summary.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/heatmap_card.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/month_summary_tile.dart';
import 'package:rituals/features/heatmaps/presentation/widgets/stat_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('the grid draws a year of days and reports the one tapped', (
    tester,
  ) async {
    DateTime? tapped;

    await tester.pumpWidget(
      _wrap(
        HeatmapCard(
          startDate: DateTime(2025, 9, 1),
          today: DateTime(2026, 8, 31),
          datasets: {DateTime(2026, 8, 30): 3, DateTime(2026, 8, 31): 5},
          onDayTapped: (day) => tapped = day,
        ),
      ),
    );

    expect(find.text('Less'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // The grid scrolls to its most recent end, so the last day is on screen.
    await tester.tap(find.byType(GestureDetector).last);
    expect(tapped, DateTime(2026, 8, 31));
  });

  testWidgets('every square is dated, under the month it belongs to', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HeatmapCard(
          startDate: DateTime(2025, 9, 1),
          today: DateTime(2026, 8, 31),
          datasets: const {},
          onDayTapped: (_) {},
        ),
      ),
    );

    // One 15th in each of the twelve months on the strip, and one 31st in
    // each of the seven months long enough to have one.
    expect(find.text('15'), findsNWidgets(12));
    expect(find.text('31'), findsNWidgets(7));

    // Every month of the range is named once, including the one today falls
    // in, whose first Sunday has not come round yet.
    for (final month in ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Aug']) {
      expect(find.text(month), findsOneWidget, reason: month);
    }
  });

  testWidgets('today and the tapped day are marked apart from each other', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HeatmapCard(
          startDate: DateTime(2026, 8, 1),
          today: DateTime(2026, 8, 31),
          datasets: const {},
          selectedDay: DateTime(2026, 8, 12),
          onDayTapped: (_) {},
        ),
      ),
    );

    final borders = tester
        .widgetList<Container>(find.byType(Container))
        .map((box) => (box.decoration as BoxDecoration?)?.border)
        .whereType<Border>()
        .toList();

    // Today is held in a moss ring, the day the reader tapped in ink. Neither
    // touches the green, which is left to say only how much was kept.
    expect(borders.where((it) => it.top.color == AppColors.moss), hasLength(1));
    expect(borders.where((it) => it.top.color == AppColors.ink), hasLength(1));
  });

  testWidgets('the week today falls in keeps running past it', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HeatmapCard(
          // A Tuesday, so Wednesday to Saturday are still to come.
          startDate: DateTime(2026, 8, 1),
          today: DateTime(2026, 9, 1),
          datasets: const {},
          onDayTapped: (_) {},
        ),
      ),
    );

    final coming = tester
        .widgetList<Container>(find.byType(Container))
        .map((box) => (box.decoration as BoxDecoration?)?.border)
        .whereType<Border>()
        .where((it) => it.top.color == AppColors.heatmapEmpty);

    expect(coming, hasLength(4));

    // Days still to come are outlines only — there is nothing to tap on a
    // day that has not happened, so only the 32 real days answer.
    expect(find.byType(GestureDetector), findsNWidgets(32));
  });

  testWidgets('a month reads back as a line of history', (tester) async {
    final august = MonthSummary()
      ..id = monthKeyOf(DateTime(2026, 8))
      ..year = 2026
      ..month = 8
      ..keptByDay = List.filled(31, 0)
      ..plannedByDay = List.filled(31, 0)
      ..kept = 18
      ..planned = 24
      ..activeDays = 12
      ..trackedDays = 15
      ..longestStreak = 5
      ..updatedAt = DateTime(2026, 8, 31)
      ..isSealed = false;

    await tester.pumpWidget(
      _wrap(MonthSummaryTile(summary: august, today: DateTime(2026, 8, 31))),
    );

    expect(find.text('August'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('18 of 24 kept · 12 active days · best run 5'), findsOne);
  });

  testWidgets('a stat card shows its number, name and caption', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const StatCard(value: '7', label: 'Days running', caption: 'Longest 9'),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('Days running'), findsOneWidget);
    expect(find.text('Longest 9'), findsOneWidget);
  });
}
