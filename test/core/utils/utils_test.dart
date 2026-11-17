import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/debouncer.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/core/utils/throttler.dart';

void main() {
  group('Debouncer', () {
    test('runs only the last action after the delay', () {
      fakeAsync((async) {
        final calls = <int>[];
        final d = Debouncer(const Duration(milliseconds: 300))
          ..run(() => calls.add(1));
        async.elapse(const Duration(milliseconds: 200));
        d.run(() => calls.add(2));
        async.elapse(const Duration(milliseconds: 299));
        expect(calls, isEmpty);
        async.elapse(const Duration(milliseconds: 1));
        expect(calls, [2]);
      });
    });

    test('flush runs the pending action immediately, once', () {
      fakeAsync((async) {
        final calls = <int>[];
        final d = Debouncer(const Duration(seconds: 1))
          ..run(() => calls.add(1));
        expect(d.isPending, isTrue);
        d.flush();
        expect(calls, [1]);
        expect(d.isPending, isFalse);
        async.elapse(const Duration(seconds: 2));
        expect(calls, [1]);
      });
    });

    test('cancel drops the pending action', () {
      fakeAsync((async) {
        final calls = <int>[];
        Debouncer(const Duration(milliseconds: 10))
          ..run(() => calls.add(1))
          ..cancel();
        async.elapse(const Duration(seconds: 1));
        expect(calls, isEmpty);
      });
    });
  });

  group('Throttler', () {
    test('runs leading call and the latest trailing call', () {
      fakeAsync((async) {
        final calls = <int>[];
        final t = Throttler(const Duration(milliseconds: 30))
          ..run(() => calls.add(1))
          ..run(() => calls.add(2))
          ..run(() => calls.add(3));
        expect(calls, [1]);
        async.elapse(const Duration(milliseconds: 30));
        expect(calls, [1, 3]);
        async.elapse(const Duration(milliseconds: 60));
        expect(calls, [1, 3]);
        t.run(() => calls.add(4));
        expect(calls, [1, 3, 4]);
      });
    });
  });

  test('FixedClock advances', () {
    final clock = FixedClock(DateTime.utc(2026, 9, 28, 10))
      ..advance(const Duration(minutes: 5));
    expect(clock.nowUtc(), DateTime.utc(2026, 9, 28, 10, 5));
  });

  test('IdGenerator returns unique v4 UUIDs', () {
    const gen = IdGenerator();
    final ids = {for (var i = 0; i < 100; i++) gen.newId()};
    expect(ids, hasLength(100));
    expect(
      ids.first,
      matches(RegExp('^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab]')),
    );
  });

  test('AppException toString includes kind and cause', () {
    const e = StorageException('write failed', cause: 'disk full');
    expect(e.toString(), 'StorageException: write failed (cause: disk full)');
    expect(
      const PermissionDeniedException('camera', permanently: true).permanently,
      isTrue,
    );
  });
}
