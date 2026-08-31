import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
          endDate: DateTime(2026, 8, 31),
          datasets: {DateTime(2026, 8, 30): 3, DateTime(2026, 8, 31): 5},
          onDayTapped: (day) => tapped = day,
        ),
      ),
    );

    expect(find.text('Less'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // The grid scrolls to its most recent end, so the last day is on screen.
    await tester.tap(find.byType(GestureDetector).last);
    expect(tapped, isNotNull);
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
