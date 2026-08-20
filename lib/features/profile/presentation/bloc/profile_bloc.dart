import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StreamProfileTestHistoryUseCase streamProfileTestHistoryUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetTestCorrectionDetailsUseCase getTestCorrectionDetailsUseCase;

  StreamSubscription? _testHistorySubscription;

  ProfileBloc({
    required this.streamProfileTestHistoryUseCase,
    required this.updateProfileUseCase,
    required this.getTestCorrectionDetailsUseCase,
  }) : super(const ProfileState()) {
    on<WatchProfileTestHistoryEvent>(_onWatchProfileTestHistory);
    on<UpdateProfileSubmittedEvent>(_onUpdateProfileSubmitted);
    on<FetchTestCorrectionDetailsEvent>(_onFetchTestCorrectionDetails);
  }

  Future<void> _onWatchProfileTestHistory(
    WatchProfileTestHistoryEvent event,
    Emitter<ProfileState> emit,
  ) async {
    dev.log('Starting watch for user test history: ${event.userId}', name: 'PROFILE_BLOC');
    await _testHistorySubscription?.cancel();
    emit(state.copyWith(isLoadingHistory: true, historyError: null));

    await emit.forEach(
      streamProfileTestHistoryUseCase(event.userId),
      onData: (result) {
        return result.fold(
          (failure) => state.copyWith(
            isLoadingHistory: false,
            historyError: failure.message,
          ),
          (historyList) => state.copyWith(
            isLoadingHistory: false,
            testHistory: historyList,
            historyError: null,
          ),
        );
      },
      onError: (error, stackTrace) {
        dev.log('Error watching test history', name: 'PROFILE_BLOC', error: error, stackTrace: stackTrace);
        return state.copyWith(
          isLoadingHistory: false,
          historyError: error.toString(),
        );
      },
    );
  }

  Future<void> _onUpdateProfileSubmitted(
    UpdateProfileSubmittedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    dev.log('Submitting profile update for user: ${event.userId}', name: 'PROFILE_BLOC');
    emit(state.copyWith(updateStatus: ProfileUpdateStatus.loading, updateError: null));

    final result = await updateProfileUseCase(
      UpdateProfileParams(userId: event.userId, data: event.data),
    );

    result.fold(
      (failure) {
        dev.log('Profile update failed: ${failure.message}', name: 'PROFILE_BLOC');
        emit(
          state.copyWith(
            updateStatus: ProfileUpdateStatus.failure,
            updateError: failure.message,
          ),
        );
      },
      (_) {
        dev.log('Profile update success', name: 'PROFILE_BLOC');
        emit(state.copyWith(updateStatus: ProfileUpdateStatus.success));
      },
    );
  }

  Future<void> _onFetchTestCorrectionDetails(
    FetchTestCorrectionDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    dev.log('Fetching test correction details: ${event.docId}', name: 'PROFILE_BLOC');
    emit(
      state.copyWith(
        isLoadingCorrection: true,
        correctionDetails: const [],
        correctionError: null,
      ),
    );

    final result = await getTestCorrectionDetailsUseCase(
      GetTestCorrectionDetailsParams(
        quizId: event.quizId,
        dateStr: event.dateStr,
        docId: event.docId,
        rawAnswers: event.rawAnswers,
      ),
    );

    result.fold(
      (failure) {
        dev.log('Fetch test correction details failed: ${failure.message}', name: 'PROFILE_BLOC');
        emit(
          state.copyWith(
            isLoadingCorrection: false,
            correctionError: failure.message,
          ),
        );
      },
      (corrections) {
        dev.log('Fetch test correction details success: ${corrections.length} questions', name: 'PROFILE_BLOC');
        emit(
          state.copyWith(
            isLoadingCorrection: false,
            correctionDetails: corrections,
            correctionError: null,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _testHistorySubscription?.cancel();
    return super.close();
  }
}
