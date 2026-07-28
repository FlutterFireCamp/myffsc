import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Une erreur serveur est survenue."]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = "Échec de l'authentification."]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "Vous n'êtes pas autorisé à accéder à cette application."]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Erreur de stockage local."]);
}
