import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/program_item.dart';

/// Contrat du module Agenda et Programmes du camp.
///
/// Gère la récupération des ateliers, conférences, sessions en direct
/// et groupes d'études avec conversion automatique des horaires GMT.
abstract class ProgramsRepository {
  /// Récupère la liste de tous les programmes à venir, filtrés optionnellement
  /// par type de session via [filterType].
  Future<Either<Failure, List<ProgramItem>>> getUpcomingPrograms({
    ProgramType? filterType,
  });

  /// Récupère le programme prévu pour aujourd'hui ou le prochain événement planifié.
  ///
  /// Retourne `null` si aucune session active ou future n'est programmée.
  Future<Either<Failure, ProgramItem?>> getTodayOrNextProgram();
}
