import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}

class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class CompleteProfileParams extends Equatable {
  final String userId;
  final Map<String, dynamic> data;

  const CompleteProfileParams({
    required this.userId,
    required this.data,
  });

  @override
  List<Object?> get props => [userId, data];
}

class CompleteProfileUseCase implements UseCase<UserEntity, CompleteProfileParams> {
  final AuthRepository repository;
  CompleteProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(CompleteProfileParams params) {
    return repository.completeProfile(
      userId: params.userId,
      data: params.data,
    );
  }
}

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
