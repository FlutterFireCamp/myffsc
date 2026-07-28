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
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitialState()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
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
        if (user.isAuthorized) {
          dev.log('Sign-In success & authorized -> AuthenticatedState (${user.name})', name: 'AUTH_BLOC');
          emit(AuthenticatedState(user));
        } else {
          dev.log('Sign-In success & unauthorized -> UnauthorizedState (${user.name})', name: 'AUTH_BLOC');
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
