import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthEvent extends AuthEvent {}

class SilentRefreshAuthUserEvent extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class CompleteProfileEvent extends AuthEvent {
  final String userId;
  final Map<String, dynamic> data;

  const CompleteProfileEvent({
    required this.userId,
    required this.data,
  });

  @override
  List<Object?> get props => [userId, data];
}

class SignOutRequested extends AuthEvent {}
