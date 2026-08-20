import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/program_item.dart';
import '../../domain/repositories/programs_repository.dart';
import '../datasources/programs_remote_data_source.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  final ProgramsRemoteDataSource remoteDataSource;

  ProgramsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProgramItem>>> getUpcomingPrograms({ProgramType? filterType}) async {
    try {
      final result = await remoteDataSource.getUpcomingPrograms(filterType: filterType);
      return Right(result);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur dans ProgramsRepositoryImpl.getUpcomingPrograms',
        name: 'PROGRAMS_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure("Impossible de charger les programmes : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ProgramItem?>> getTodayOrNextProgram() async {
    try {
      final result = await remoteDataSource.getTodayOrNextProgram();
      return Right(result);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur dans ProgramsRepositoryImpl.getTodayOrNextProgram',
        name: 'PROGRAMS_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure("Impossible de charger le programme du jour : ${e.toString()}"));
    }
  }
}
