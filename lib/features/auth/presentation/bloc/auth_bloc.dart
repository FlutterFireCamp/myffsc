import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final CompleteProfileUseCase completeProfileUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.signInWithGoogleUseCase,
    required this.completeProfileUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitialState()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SilentRefreshAuthUserEvent>(_onSilentRefreshAuthUser);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<CompleteProfileEvent>(_onCompleteProfile);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    dev.log('Handling CheckAuthEvent', name: 'AUTH_BLOC');
    emit(AuthLoadingState());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        dev.log('CheckAuth failed: ${failure.message}', name: 'AUTH_BLOC');
        emit(AuthErrorState(failure.message));
      },
      (user) {
        if (user == null) {
          dev.log('User is null -> UnauthenticatedState', name: 'AUTH_BLOC');
          emit(UnauthenticatedState());
        } else if (user.isProfileIncomplete) {
          dev.log('User profile incomplete -> ProfileIncompleteState (${user.email})', name: 'AUTH_BLOC');
          emit(ProfileIncompleteState(user));
        } else if (user.isAuthorized) {
          dev.log('User authorized -> AuthenticatedState (${user.name})', name: 'AUTH_BLOC');
          emit(AuthenticatedState(user));
        } else {
          dev.log('User unauthorized -> UnauthorizedState (${user.name})', name: 'AUTH_BLOC');
          emit(UnauthorizedState(user));
        }
      },
    );
  }

  Future<void> _onSilentRefreshAuthUser(
    SilentRefreshAuthUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    dev.log('Handling SilentRefreshAuthUserEvent', name: 'AUTH_BLOC');
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        dev.log('SilentRefresh failed: ${failure.message}', name: 'AUTH_BLOC');
      },
      (user) {
        if (user != null) {
          if (user.isAuthorized) {
            dev.log('SilentRefresh: updated AuthenticatedState (${user.name})', name: 'AUTH_BLOC');
            emit(AuthenticatedState(user));
          } else if (user.isProfileIncomplete) {
            emit(ProfileIncompleteState(user));
          } else {
            emit(UnauthorizedState(user));
          }
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    dev.log('Handling SignInWithGoogleRequested', name: 'AUTH_BLOC');
    emit(AuthLoadingState());
    final result = await signInWithGoogleUseCase(NoParams());

    result.fold(
      (failure) {
        if (failure is UserCanceledFailure) {
          dev.log('SignInWithGoogle cancelled by user -> emit UnauthenticatedState', name: 'AUTH_BLOC');
          emit(UnauthenticatedState());
        } else {
          dev.log('SignInWithGoogle failed: ${failure.message}', name: 'AUTH_BLOC');
          emit(AuthErrorState(failure.message));
        }
      },
      (user) {
        if (user.isProfileIncomplete) {
          dev.log('Sign-In success & profile incomplete -> ProfileIncompleteState (${user.email})', name: 'AUTH_BLOC');
          emit(ProfileIncompleteState(user));
        } else if (user.isAuthorized) {
          dev.log('Sign-In success & authorized -> AuthenticatedState (${user.name})', name: 'AUTH_BLOC');
          emit(AuthenticatedState(user));
        } else {
          dev.log('Sign-In success & unauthorized -> UnauthorizedState (${user.name})', name: 'AUTH_BLOC');
          emit(UnauthorizedState(user));
        }
      },
    );
  }

  Future<void> _onCompleteProfile(
    CompleteProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    dev.log('Handling CompleteProfileEvent for userId: ${event.userId}', name: 'AUTH_BLOC');
    emit(AuthLoadingState());
    final result = await completeProfileUseCase(
      CompleteProfileParams(userId: event.userId, data: event.data),
    );

    result.fold(
      (failure) {
        dev.log('CompleteProfile failed: ${failure.message}', name: 'AUTH_BLOC');
        emit(AuthErrorState(failure.message));
      },
      (user) {
        if (user.isProfileIncomplete) {
          dev.log('CompleteProfile success but still incomplete -> ProfileIncompleteState', name: 'AUTH_BLOC');
          emit(ProfileIncompleteState(user));
        } else if (user.isAuthorized) {
          dev.log('CompleteProfile success & authorized -> AuthenticatedState (${user.name})', name: 'AUTH_BLOC');
          emit(AuthenticatedState(user));
        } else {
          dev.log('CompleteProfile success & unauthorized -> UnauthorizedState (${user.name})', name: 'AUTH_BLOC');
          emit(UnauthorizedState(user));
        }
      },
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    dev.log('Handling SignOutRequested', name: 'AUTH_BLOC');
    emit(AuthLoadingState());
    final result = await signOutUseCase(NoParams());

    result.fold(
      (failure) {
        dev.log('SignOut failed: ${failure.message}', name: 'AUTH_BLOC');
        emit(AuthErrorState(failure.message));
      },
      (_) {
        dev.log('SignOut success -> UnauthenticatedState', name: 'AUTH_BLOC');
        emit(UnauthenticatedState());
      },
    );
  }
}
