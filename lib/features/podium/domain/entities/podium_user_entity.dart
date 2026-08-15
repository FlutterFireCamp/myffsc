import 'package:equatable/equatable.dart';
import '../../../../core/utils/country_flag_helper.dart';

class PodiumUserEntity extends Equatable {
  final String id;
  final String name;
  final String? photoUrl;
  final String? country;
  final String? community;
  final String? hub;
  final int totalPoints;
  final int level;
  final int rank;

  const PodiumUserEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    this.country,
    this.community,
    this.hub,
    required this.totalPoints,
    required this.level,
    required this.rank,
  });

  String get flag => CountryFlagHelper.getFlag(country);

  String get displayCommunity {
    final val = hub ?? community;
    if (val != null && val.trim().isNotEmpty) {
      return val.trim();
    }
    return '';
  }

  factory PodiumUserEntity.fromFirestore(
    Map<String, dynamic> data,
    String id,
    int rank,
  ) {
    return PodiumUserEntity(
      id: id,
      name: data['name'] as String? ?? 'Apprenant',
      photoUrl: data['photoUrl'] as String?,
      country: data['country'] as String?,
      community: data['community'] as String?,
      hub: data['hub'] as String?,
      totalPoints: (data['totalPoints'] as num?)?.toInt() ?? 0,
      level: (data['level'] as num?)?.toInt() ?? 1,
      rank: rank,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        country,
        community,
        hub,
        totalPoints,
        level,
        rank,
      ];
}
