import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myffsc/core/helpers/date_time_helper.dart';

void main() {
  group('DateTimeHelper Tests (GMT 0 -> Local Device)', () {
    test('parseToLocal with UTC ISO string should return local DateTime', () {
      const utcString = "2026-08-18T14:30:00Z";
      final result = DateTimeHelper.parseToLocal(utcString);

      expect(result, isNotNull);
      expect(result!.isUtc, isFalse);
      expect(result.toUtc().hour, equals(14));
      expect(result.toUtc().minute, equals(30));
    });

    test('parseToLocal with Firestore Timestamp should convert to local DateTime', () {
      final timestamp = Timestamp.fromDate(DateTime.utc(2026, 8, 18, 10, 0));
      final result = DateTimeHelper.parseToLocal(timestamp);

      expect(result, isNotNull);
      expect(result!.isUtc, isFalse);
      expect(result.toUtc().hour, equals(10));
    });

    test('parseToLocal with YYYY-MM-DD string should return valid local DateTime', () {
      const ymdString = "2026-08-18";
      final result = DateTimeHelper.parseToLocal(ymdString);

      expect(result, isNotNull);
      expect(result!.year, equals(2026));
      expect(result.month, equals(8));
      expect(result.day, equals(18));
    });

    test('isToday returns true for today date and false for past/future date', () {
      final now = DateTime.now();
      expect(DateTimeHelper.isToday(now), isTrue);

      final yesterday = now.subtract(const Duration(days: 1));
      expect(DateTimeHelper.isToday(yesterday), isFalse);

      final tomorrow = now.add(const Duration(days: 1));
      expect(DateTimeHelper.isToday(tomorrow), isFalse);
    });

    test('isPast correctly checks if date has passed', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 2));
      expect(DateTimeHelper.isPast(pastDate), isTrue);

      final futureDate = DateTime.now().add(const Duration(hours: 2));
      expect(DateTimeHelper.isPast(futureDate), isFalse);
    });

    test('formatFrenchDate outputs readable french string', () {
      final date = DateTime(2026, 8, 18);
      expect(DateTimeHelper.formatFrenchDate(date), equals('18 août 2026'));
    });

    test('formatYmd outputs standardized YYYY-MM-DD string', () {
      final date = DateTime(2026, 8, 18);
      expect(DateTimeHelper.formatYmd(date), equals('2026-08-18'));
    });
  });
}
