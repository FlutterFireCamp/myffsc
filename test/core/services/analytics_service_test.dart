import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/core/services/analytics_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late AnalyticsService service;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    service = AnalyticsService(analytics: mockAnalytics);
  });

  group('AnalyticsService', () {
    test('returns a valid FirebaseAnalyticsObserver', () {
      final observer = service.observer;
      expect(observer, isA<FirebaseAnalyticsObserver>());
      expect(observer!.analytics, equals(mockAnalytics));
    });

    test('returns null observer and safely does nothing when isAvailable is false', () async {
      final disabledService = AnalyticsService(analytics: null, isAvailable: false);
      expect(disabledService.observer, isNull);
      await disabledService.logEvent(name: 'custom_event');
      await disabledService.logScreenView(screenName: 'Screen');
      await disabledService.setUserId('123');
      await disabledService.setUserProperty(name: 'a', value: 'b');
      await disabledService.logLogin();
    });

    test('logEvent delegates to FirebaseAnalytics.logEvent', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      await service.logEvent(name: 'custom_event', parameters: {'key': 'val'});

      verify(
        () => mockAnalytics.logEvent(
          name: 'custom_event',
          parameters: {'key': 'val'},
        ),
      ).called(1);
    });

    test('logScreenView delegates to FirebaseAnalytics.logScreenView', () async {
      when(
        () => mockAnalytics.logScreenView(
          screenName: any(named: 'screenName'),
          screenClass: any(named: 'screenClass'),
        ),
      ).thenAnswer((_) async {});

      await service.logScreenView(screenName: 'DashboardPage');

      verify(
        () => mockAnalytics.logScreenView(
          screenName: 'DashboardPage',
          screenClass: any(named: 'screenClass'),
        ),
      ).called(1);
    });

    test('setUserId delegates to FirebaseAnalytics.setUserId', () async {
      when(() => mockAnalytics.setUserId(id: any(named: 'id')))
          .thenAnswer((_) async {});

      await service.setUserId('user_123');

      verify(() => mockAnalytics.setUserId(id: 'user_123')).called(1);
    });

    test('setUserProperty delegates to FirebaseAnalytics.setUserProperty', () async {
      when(
        () => mockAnalytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await service.setUserProperty(name: 'role', value: 'student');

      verify(
        () => mockAnalytics.setUserProperty(name: 'role', value: 'student'),
      ).called(1);
    });

    test('logLogin delegates to FirebaseAnalytics.logLogin', () async {
      when(
        () => mockAnalytics.logLogin(
          loginMethod: any(named: 'loginMethod'),
        ),
      ).thenAnswer((_) async {});

      await service.logLogin(loginMethod: 'google');

      verify(
        () => mockAnalytics.logLogin(loginMethod: 'google'),
      ).called(1);
    });

    test('logTestStarted calls logEvent with appropriate parameters', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      await service.logTestStarted(
        testId: 'test_1',
        testTitle: 'Examen Final',
      );

      verify(
        () => mockAnalytics.logEvent(
          name: 'test_started',
          parameters: {
            'test_id': 'test_1',
            'test_title': 'Examen Final',
          },
        ),
      ).called(1);
    });

    test('logTestCompleted calls logEvent with score and question count', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      await service.logTestCompleted(
        testId: 'test_1',
        testTitle: 'Examen Final',
        score: 18,
        totalQuestions: 20,
      );

      verify(
        () => mockAnalytics.logEvent(
          name: 'test_completed',
          parameters: {
            'test_id': 'test_1',
            'test_title': 'Examen Final',
            'score': 18,
            'total_questions': 20,
          },
        ),
      ).called(1);
    });

    test('logFormSubmitted calls logEvent with form details', () async {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      await service.logFormSubmitted(
        formId: 'form_1',
        formTitle: 'Feedback Session',
      );

      verify(
        () => mockAnalytics.logEvent(
          name: 'form_submitted',
          parameters: {
            'form_id': 'form_1',
            'form_title': 'Feedback Session',
          },
        ),
      ).called(1);
    });
  });
}
