import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/core/core.dart';
import 'package:myffsc/features/auth/data/models/user_model.dart';
import 'package:myffsc/features/auth/domain/usecases/auth_usecases.dart';
import 'package:myffsc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myffsc/features/auth/presentation/bloc/auth_event.dart';
import 'package:myffsc/features/auth/presentation/bloc/auth_state.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockSignInWithGoogleUseCase extends Mock implements SignInWithGoogleUseCase {}
class MockCompleteProfileUseCase extends Mock implements CompleteProfileUseCase {}
class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockCompleteProfileUseCase mockCompleteProfileUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const CompleteProfileParams(userId: 'test', data: {}));
  });

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockCompleteProfileUseCase = MockCompleteProfileUseCase();
    mockSignOutUseCase = MockSignOutUseCase();

    authBloc = AuthBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      completeProfileUseCase: mockCompleteProfileUseCase,
      signOutUseCase: mockSignOutUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  const tAcceptedUser = UserModel(
    id: 'user_123',
    name: 'Jean Dupont',
    email: 'jean@example.com',
    role: 'student',
    level: 1,
    status: 'accepted',
    totalPoints: 100,
  );

  const tUnauthorizedUser = UserModel(
    id: 'user_456',
    name: 'Paul Martin',
    email: 'paul@example.com',
    role: 'student',
    level: 1,
    status: 'pending',
  );

  group('AuthBloc - CheckAuthEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthenticatedState] when user is accepted',
      build: () {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(tAcceptedUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthEvent()),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthenticatedState>().having(
          (s) => s.user.isAuthorized,
          'isAuthorized',
          true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnauthorizedState] when user is pending / not accepted',
      build: () {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(tUnauthorizedUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthEvent()),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<UnauthorizedState>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnauthenticatedState] when no user is logged in',
      build: () {
        when(() => mockGetCurrentUserUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthEvent()),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<UnauthenticatedState>(),
      ],
    );
  });

  group('AuthBloc - CompleteProfileEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthenticatedState] when completeProfile is successful and user is authorized',
      build: () {
        when(() => mockCompleteProfileUseCase(any()))
            .thenAnswer((_) async => const Right(tAcceptedUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const CompleteProfileEvent(
        userId: 'user_123',
        data: {'name': 'Jean Dupont'},
      )),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<AuthenticatedState>(),
      ],
    );
  });

  group('AuthBloc - SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnauthenticatedState] on successful sign out',
      build: () {
        when(() => mockSignOutUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        isA<AuthLoadingState>(),
        isA<UnauthenticatedState>(),
      ],
    );
  });
}
