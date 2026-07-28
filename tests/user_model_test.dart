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
    );

    test('should extract firstName correctly from full name', () {
      expect(tUserModel.firstName, 'Jean');
    });

    test('should verify authorization correctly when role is student and status is accepted', () {
      expect(tUserModel.isAuthorized, true);
    });

    test('should fail authorization if status is pending', () {
      final pendingUser = UserModel(
        id: 'user_456',
        name: 'Marie Curie',
        email: 'marie@example.com',
        role: 'student',
        level: 1,
        status: 'pending',
      );
      expect(pendingUser.isAuthorized, false);
    });

    test('should convert to Map and from Map correctly', () {
      final map = tUserModel.toMap();
      final result = UserModel.fromMap(map, 'user_123');
      expect(result.id, tUserModel.id);
      expect(result.name, tUserModel.name);
      expect(result.role, tUserModel.role);
      expect(result.level, tUserModel.level);
      expect(result.status, tUserModel.status);
    });
  });
}
