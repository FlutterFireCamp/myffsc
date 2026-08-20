import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/program_item.dart';
import '../repositories/programs_repository.dart';

class GetUpcomingProgramsParams extends Equatable {
  final ProgramType? filterType;

  const GetUpcomingProgramsParams({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

class GetUpcomingProgramsUseCase implements UseCase<List<ProgramItem>, GetUpcomingProgramsParams> {
  final ProgramsRepository repository;

  GetUpcomingProgramsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProgramItem>>> call(GetUpcomingProgramsParams params) async {
    return await repository.getUpcomingPrograms(filterType: params.filterType);
  }
}

class GetTodayOrNextProgramUseCase implements UseCase<ProgramItem?, NoParams> {
  final ProgramsRepository repository;

  GetTodayOrNextProgramUseCase(this.repository);

  @override
  Future<Either<Failure, ProgramItem?>> call(NoParams params) async {
    return await repository.getTodayOrNextProgram();
  }
}
