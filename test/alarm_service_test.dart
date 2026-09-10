import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rituals/core/services/alarm_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.example.rituals/alarm');
  const service = AlarmService();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  /// Stands in for the Android side, answering every call with [reply].
  void clockApp(Object? Function() reply) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return reply();
    });
  }

  tearDown(() {
    calls.clear();
    messenger.setMockMethodCallHandler(channel, null);
  });

  group('AlarmService.setAlarm', () {
    test('sends the repeat days along with the time and label', () async {
      clockApp(() => true);

      final result = await service.setAlarm(
        hour: 7,
        minute: 30,
        label: 'Morning Run',
        days: [1, 3, 5],
      );

      expect(result, AlarmResult.set);
      expect(calls.single.method, 'setAlarm');
      expect(calls.single.arguments, {
        'hour': 7,
        'minute': 30,
        'label': 'Morning Run',
        'days': [1, 3, 5],
      });
    });

    test('reports a device with no clock app to hand it to', () async {
      clockApp(() => false);

      expect(
        await service.setAlarm(hour: 7, minute: 30, label: 'Morning Run'),
        AlarmResult.noClockApp,
      );
    });

    test('turns a platform error into a failure rather than throwing', () async {
      clockApp(() => throw PlatformException(code: 'PERMISSION_DENIED'));

      expect(
        await service.setAlarm(hour: 7, minute: 30, label: 'Morning Run'),
        AlarmResult.failed,
      );
    });
  });
}
