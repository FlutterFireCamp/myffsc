import 'package:flutter_test/flutter_test.dart';
import 'package:myffsc/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    const tUserModel = UserModel(
      id: 'user_123',
      name: 'Jean Dupont',
      email: 'jean.dupont@example.com',
      role: 'student',
      level: 2,
      status: 'accepted',
      country: 'Sénégal',
      town: 'Dakar',
      discordUsername: 'jeandupont#1234',
      gender: 'M',
      totalPoints: 150,
      certificateCode: 'FFC-2026-LRN-CUV7GL',
    );

    test('should extract firstName correctly from full name', () {
      expect(tUserModel.firstName, 'Jean');
    });

    test('should verify authorization correctly when role is student and status is accepted', () {
      expect(tUserModel.isAuthorized, true);
    });

    test('should fail authorization if status is pending', () {
      const pendingUser = UserModel(
        id: 'user_456',
        name: 'Marie Curie',
        email: 'marie@example.com',
        role: 'student',
        level: 1,
        status: 'pending',
      );
      expect(pendingUser.isAuthorized, false);
    });

    test('should identify certificate presence and build correct verification URL', () {
      expect(tUserModel.hasCertificate, true);
      expect(
        tUserModel.certificateVerificationUrl,
        'https://www.flutterfirecamp.dev/verify/FFC-2026-LRN-CUV7GL',
      );

      const userWithoutCert = UserModel(
        id: 'user_789',
        name: 'Paul Martin',
        email: 'paul@example.com',
        role: 'student',
        level: 1,
        status: 'accepted',
      );
      expect(userWithoutCert.hasCertificate, false);
      expect(
        userWithoutCert.certificateVerificationUrl,
        'https://www.flutterfirecamp.dev/verify/',
      );
    });

    test('should convert to Map and from Map correctly including certificateCode', () {
      final map = tUserModel.toMap();
      expect(map['certificateCode'], 'FFC-2026-LRN-CUV7GL');

      final result = UserModel.fromMap(map, 'user_123');
      expect(result.id, tUserModel.id);
      expect(result.name, tUserModel.name);
      expect(result.role, tUserModel.role);
      expect(result.level, tUserModel.level);
      expect(result.status, tUserModel.status);
      expect(result.certificateCode, 'FFC-2026-LRN-CUV7GL');
    });

    test('should support alternative Firestore keys for certificate', () {
      final mapWithCertificateId = {
        'name': 'Alioune',
        'certificateId': 'FFC-2026-LRN-ALI99',
      };
      final user1 = UserModel.fromMap(mapWithCertificateId, 'u1');
      expect(user1.certificateCode, 'FFC-2026-LRN-ALI99');

      final mapWithCertificate = {
        'name': 'Fatou',
        'certificate': 'FFC-2026-LRN-FAT10',
      };
      final user2 = UserModel.fromMap(mapWithCertificate, 'u2');
      expect(user2.certificateCode, 'FFC-2026-LRN-FAT10');
    });
  });
}
