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

  static String month(DateTime date) => months[date.month - 1];

  static String shortMonth(DateTime date) => month(date).substring(0, 3);

  /// `Monday · 31 August` — the line above the day's list.
  static String dayLine(DateTime date) =>
      '${weekday(date)} · ${date.day} ${month(date)}';

  /// `31 August` — a day named without its weekday.
  static String dayAndMonth(DateTime date) => '${date.day} ${month(date)}';

  /// `August 2026`, or just `August` when [date] falls in [relativeTo]'s year.
  static String monthYear(DateTime date, {DateTime? relativeTo}) {
    if (relativeTo != null && relativeTo.year == date.year) return month(date);
    return '${month(date)} ${date.year}';
  }
}
