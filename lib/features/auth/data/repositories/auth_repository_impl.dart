import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } catch (e, stackTrace) {
      dev.log(
        'AuthRepository.signInWithGoogle failed',
        name: 'AUTH_REPOSITORY',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e, stackTrace) {
      dev.log(
        'AuthRepository.getCurrentUser failed',
        name: 'AUTH_REPOSITORY',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e, stackTrace) {
      dev.log(
        'AuthRepository.signOut failed',
        name: 'AUTH_REPOSITORY',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
