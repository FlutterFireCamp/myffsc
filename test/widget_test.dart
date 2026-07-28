import 'package:flutter_test/flutter_test.dart';
import 'package:myffsc/features/auth/data/models/user_model.dart';

void main() {
  test('Smoke test - User entity authorization', () {
    const user = UserModel(
      id: '1',
      name: 'Test Learner',
      email: 'test@flutterfirecamp.com',
      role: 'student',
      level: 1,
      status: 'accepted',
    );

    expect(user.isAuthorized, true);
    expect(user.firstName, 'Test');
  });
}
