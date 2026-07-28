import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(AuthLoadingState());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) {
        if (user == null) {
          emit(UnauthenticatedState());
        } else if (user.isAuthorized) {
          emit(AuthenticatedState(user));
        } else {
          emit(UnauthorizedState(user));
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await signInWithGoogleUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) {
        if (user.isAuthorized) {
          emit(AuthenticatedState(user));
        } else {
          emit(UnauthorizedState(user));
        }
      },
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await signOutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(UnauthenticatedState()),
    );
  }
}
