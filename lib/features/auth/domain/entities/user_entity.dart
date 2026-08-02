import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final int level;
  final String status;
  final String? country;
  final String? town;
  final String? community;
  final String? hub;
  final String? discordUsername;
  final String? gender;
  final String? photoUrl;
  final String? github;
  final String? linkedin;
  final String? x;
  final String? portfolio;
  final int totalPoints;
  final String? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.level,
    required this.status,
    this.country,
    this.town,
    this.community,
    this.hub,
    this.discordUsername,
    this.gender,
    this.photoUrl,
    this.github,
    this.linkedin,
    this.x,
    this.portfolio,
    this.totalPoints = 0,
    this.createdAt,
  });

  String get firstName {
    if (name.isEmpty) return 'Apprenant';
    return name.trim().split(' ').first;
  }

  bool get isAuthorized => role == 'student' && status == 'accepted';
  bool get isDocMissing => status == 'not_found' || status == 'not_registered';
  bool get isPending => status == 'pending';
  bool get isSuspended => status == 'suspended';
  bool get isProfileIncomplete =>
      !isDocMissing && (name.trim().isEmpty || name == 'Apprenant FFSC');

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        level,
        status,
        country,
        town,
        community,
        hub,
        discordUsername,
        gender,
        photoUrl,
        github,
        linkedin,
        x,
        portfolio,
        totalPoints,
        createdAt,
      ];
}
