import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/program_item.dart';

abstract class ProgramsRepository {
  Future<Either<Failure, List<ProgramItem>>> getUpcomingPrograms({ProgramType? filterType});
  Future<Either<Failure, ProgramItem?>> getTodayOrNextProgram();
}
