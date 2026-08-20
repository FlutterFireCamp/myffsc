import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/core/error/failures.dart';
import 'package:myffsc/features/profile/domain/entities/user_test_history_entity.dart';
import 'package:myffsc/features/profile/domain/usecases/profile_usecases.dart';
import 'package:myffsc/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:myffsc/features/profile/presentation/bloc/profile_event.dart';
import 'package:myffsc/features/profile/presentation/bloc/profile_state.dart';
import 'package:myffsc/features/tests/domain/entities/user_question_correction.dart';

class MockStreamProfileTestHistoryUseCase extends Mock
    implements StreamProfileTestHistoryUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockGetTestCorrectionDetailsUseCase extends Mock
    implements GetTestCorrectionDetailsUseCase {}

void main() {
  late MockStreamProfileTestHistoryUseCase mockStreamHistory;
  late MockUpdateProfileUseCase mockUpdateProfile;
  late MockGetTestCorrectionDetailsUseCase mockGetCorrection;
  late ProfileBloc profileBloc;

  setUpAll(() {
    registerFallbackValue(const UpdateProfileParams(userId: 'test', data: {}));
    registerFallbackValue(
      const GetTestCorrectionDetailsParams(
        quizId: 'quiz_1',
        dateStr: '2026-08-20',
        docId: 'doc_1',
        rawAnswers: null,
      ),
    );
  });

  setUp(() {
    mockStreamHistory = MockStreamProfileTestHistoryUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();
    mockGetCorrection = MockGetTestCorrectionDetailsUseCase();

    profileBloc = ProfileBloc(
      streamProfileTestHistoryUseCase: mockStreamHistory,
      updateProfileUseCase: mockUpdateProfile,
      getTestCorrectionDetailsUseCase: mockGetCorrection,
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  const tHistoryItem = UserTestHistoryEntity(
    docId: '2026-08-20_quiz1',
    quizTitle: 'Test Flutter 1',
    dateStr: '2026-08-20',
    score: 80,
    totalPossibleScore: 100,
    status: 'completed',
  );

  group('ProfileBloc - WatchProfileTestHistoryEvent', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits updated testHistory when stream succeeds',
      build: () {
        when(() => mockStreamHistory(any())).thenAnswer(
          (_) => Stream.value(const Right([tHistoryItem])),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(const WatchProfileTestHistoryEvent('user_123')),
      expect: () => [
        const ProfileState(isLoadingHistory: true),
        const ProfileState(
          isLoadingHistory: false,
          testHistory: [tHistoryItem],
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits historyError when stream yields failure',
      build: () {
        when(() => mockStreamHistory(any())).thenAnswer(
          (_) => Stream.value(const Left(ServerFailure('Database error'))),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(const WatchProfileTestHistoryEvent('user_123')),
      expect: () => [
        const ProfileState(isLoadingHistory: true),
        const ProfileState(
          isLoadingHistory: false,
          historyError: 'Database error',
        ),
      ],
    );
  });

  group('ProfileBloc - UpdateProfileSubmittedEvent', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, success] on successful profile update',
      build: () {
        when(() => mockUpdateProfile(any()))
            .thenAnswer((_) async => const Right(null));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const UpdateProfileSubmittedEvent(
        userId: 'user_123',
        data: {'town': 'Goma'},
      )),
      expect: () => [
        const ProfileState(updateStatus: ProfileUpdateStatus.loading),
        const ProfileState(updateStatus: ProfileUpdateStatus.success),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, failure] on failed profile update',
      build: () {
        when(() => mockUpdateProfile(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const UpdateProfileSubmittedEvent(
        userId: 'user_123',
        data: {'town': 'Goma'},
      )),
      expect: () => [
        const ProfileState(updateStatus: ProfileUpdateStatus.loading),
        const ProfileState(
          updateStatus: ProfileUpdateStatus.failure,
          updateError: 'Network error',
        ),
      ],
    );
  });

  group('ProfileBloc - FetchTestCorrectionDetailsEvent', () {
    const tCorrection = UserQuestionCorrection(
      index: 0,
      questionId: 'q_0',
      title: 'Question 1',
      statement: 'What is Flutter?',
      type: 'choice',
      studentAnswer: '0',
      earnedScore: 100,
      maxScore: 100,
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [isLoadingCorrection: true, isLoadingCorrection: false with data] on success',
      build: () {
        when(() => mockGetCorrection(any()))
            .thenAnswer((_) async => const Right([tCorrection]));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchTestCorrectionDetailsEvent(
        quizId: 'quiz_1',
        dateStr: '2026-08-20',
        docId: 'doc_1',
        rawAnswers: null,
      )),
      expect: () => [
        const ProfileState(isLoadingCorrection: true),
        const ProfileState(
          isLoadingCorrection: false,
          correctionDetails: [tCorrection],
        ),
      ],
    );
  });
}
