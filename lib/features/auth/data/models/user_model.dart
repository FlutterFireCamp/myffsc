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
    super.certificateCode,
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
      certificateCode: map['certificateCode'] as String? ??
          map['certificateId'] as String? ??
          map['certificate'] as String? ??
          map['certificateUrl'] as String?,
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
      if (certificateCode != null) 'certificateCode': certificateCode,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    int? level,
    String? status,
    String? country,
    String? town,
    String? community,
    String? hub,
    String? discordUsername,
    String? gender,
    String? photoUrl,
    String? github,
    String? linkedin,
    String? x,
    String? portfolio,
    int? totalPoints,
    String? createdAt,
    String? certificateCode,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      level: level ?? this.level,
      status: status ?? this.status,
      country: country ?? this.country,
      town: town ?? this.town,
      community: community ?? this.community,
      hub: hub ?? this.hub,
      discordUsername: discordUsername ?? this.discordUsername,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      x: x ?? this.x,
      portfolio: portfolio ?? this.portfolio,
      totalPoints: totalPoints ?? this.totalPoints,
      createdAt: createdAt ?? this.createdAt,
      certificateCode: certificateCode ?? this.certificateCode,
    );
  }
}
