import 'package:flutter_test/flutter_test.dart';
import 'package:rituals/core/utils/date_labels.dart';

void main() {
  group('DateLabels.repeatDays', () {
    test('names the common schedules', () {
      expect(DateLabels.repeatDays([1, 2, 3, 4, 5, 6, 7]), 'Daily');
      expect(DateLabels.repeatDays([1, 2, 3, 4, 5]), 'Weekdays');
      expect(DateLabels.repeatDays([6, 7]), 'Weekends');
    });

    test('lists scattered days in week order', () {
      expect(DateLabels.repeatDays([5, 1, 3]), 'Mon, Wed, Fri');
      expect(DateLabels.repeatDays([1, 2, 4, 6]), 'Mon, Tue, Thu, Sat');
    });

    test('shortens an unbroken run of three or more to a range', () {
      expect(DateLabels.repeatDays([1, 2, 3, 4, 5, 6]), 'Mon–Sat');
      expect(DateLabels.repeatDays([2, 3, 4]), 'Tue–Thu');
    });

    test('keeps a pair or a single day as names', () {
      expect(DateLabels.repeatDays([1, 2]), 'Mon, Tue');
      expect(DateLabels.repeatDays([3]), 'Wed');
    });

    test('ignores repeats in the input', () {
      expect(DateLabels.repeatDays([3, 3, 1]), 'Mon, Wed');
    });
  });

  group('DateLabels weekday names', () {
    test('shortens and initials an ISO weekday', () {
      expect(DateLabels.shortWeekday(1), 'Mon');
      expect(DateLabels.shortWeekday(7), 'Sun');
      expect(DateLabels.weekdayInitial(4), 'T');
    });
  });
}
