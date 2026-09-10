/// The app's date wording, in one place so the list and the heatmap agree.
abstract final class DateLabels {
  static const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String weekday(DateTime date) => weekdays[date.weekday - 1];

  /// `Mon` for ISO weekday 1.
  static String shortWeekday(int weekday) =>
      weekdays[weekday - 1].substring(0, 3);

  /// `M` for ISO weekday 1 — ambiguous alone, so only shown in a week row.
  static String weekdayInitial(int weekday) => weekdays[weekday - 1][0];

  /// How a repeat schedule of ISO weekdays reads in a tag: `Daily`,
  /// `Weekdays`, `Weekends`, `Mon–Thu` for an unbroken run of three or more,
  /// and otherwise `Mon, Wed, Fri`.
  static String repeatDays(Iterable<int> days) {
    final sorted = days.toSet().toList()..sort();

    switch (sorted.join()) {
      case '1234567':
        return 'Daily';
      case '12345':
        return 'Weekdays';
      case '67':
        return 'Weekends';
    }

    final isRun = sorted.last - sorted.first == sorted.length - 1;
    if (sorted.length >= 3 && isRun) {
      return '${shortWeekday(sorted.first)}–${shortWeekday(sorted.last)}';
    }
    return sorted.map(shortWeekday).join(', ');
  }

  static String month(DateTime date) => months[date.month - 1];

  static String shortMonth(DateTime date) => month(date).substring(0, 3);

  /// `Monday · 31 August` — the line above the day's list.
  static String dayLine(DateTime date) =>
      '${weekday(date)} · ${date.day} ${month(date)}';

  /// `31 August` — a day named without its weekday.
  static String dayAndMonth(DateTime date) => '${date.day} ${month(date)}';

  /// `15 August 2026` — a day named in full, for the date a history starts on.
  static String dayMonthYear(DateTime date) =>
      '${date.day} ${month(date)} ${date.year}';

  /// `August 2026`, or just `August` when [date] falls in [relativeTo]'s year.
  static String monthYear(DateTime date, {DateTime? relativeTo}) {
    if (relativeTo != null && relativeTo.year == date.year) return month(date);
    return '${month(date)} ${date.year}';
  }
}
