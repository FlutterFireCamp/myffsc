import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.level,
    required super.status,
    super.country,
    super.town,
    super.community,
    super.hub,
    super.discordUsername,
    super.gender,
    super.photoUrl,
    super.github,
    super.linkedin,
    super.x,
    super.portfolio,
    super.totalPoints,
    super.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? 'Apprenant FFSC',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'student',
      level: (map['level'] as num?)?.toInt() ?? 1,
      status: map['status'] as String? ?? 'pending',
      country: map['country'] as String?,
      town: map['town'] as String?,
      community: map['community'] as String?,
      hub: map['hub'] as String?,
      discordUsername: map['discordUsername'] as String?,
      gender: map['gender'] as String?,
      photoUrl: map['photoUrl'] as String?,
      github: map['github'] as String?,
      linkedin: map['linkedin'] as String?,
      x: map['x'] as String?,
      portfolio: map['portfolio'] as String?,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'level': level,
      'status': status,
      'country': country,
      'town': town,
      'community': community,
      'hub': hub,
      'discordUsername': discordUsername,
      'gender': gender,
      'photoUrl': photoUrl,
      'github': github,
      'linkedin': linkedin,
      'x': x,
      'portfolio': portfolio,
      'totalPoints': totalPoints,
      'createdAt': createdAt,
    };
  }
}
