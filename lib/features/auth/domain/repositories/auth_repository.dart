import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contrat d'authentification et de gestion de session apprenant.
///
/// Implémenté par `AuthRepositoryImpl` pour interagir avec Firebase Auth
/// et la collection Firestore `users`.
abstract class AuthRepository {
  /// Déclenche le flux d'authentification Google Sign-In.
  ///
  /// Retourne un [UserEntity] synchronisé avec Firestore ou un [AuthFailure].
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Récupère l'utilisateur actuellement connecté s'il existe en cache/session.
  ///
  /// Retourne `null` si aucune session active n'est détectée.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Complète ou met à jour les informations du profil initial de l'apprenant.
  ///
  /// Prend en paramètre l'identifiant unique [userId] et la map de données [data].
  Future<Either<Failure, UserEntity>> completeProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Déconnecte l'utilisateur de Google Sign-In et de Firebase Auth.
  Future<Either<Failure, void>> signOut();
}
