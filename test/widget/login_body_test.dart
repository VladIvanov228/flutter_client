import 'package:flutter_test/flutter_test.dart';
import 'package:project_program/entity/login_body.dart';

void main() {
  group('LoginBody', () {
    test('fromJson should create LoginBody from JSON', () {
      final json = {
        'id': '1234567890',
        'role': 'admin',
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
      };

      final loginBody = LoginBody.fromJson(json);

      expect(loginBody.id, 1234567890);
      expect(loginBody.role, 'admin');
      expect(loginBody.token, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
    });

    test('fromJson should handle numeric ID', () {
      final json = {
        'id': 9876543210,
        'role': 'user',
        'token': 'another_token_here'
      };

      final loginBody = LoginBody.fromJson(json);

      expect(loginBody.id, 9876543210);
      expect(loginBody.role, 'user');
      expect(loginBody.token, 'another_token_here');
    });

    test('Constructor should initialize all fields', () {
      final loginBody = LoginBody(
        id: 1112223334,
        role: 'moderator',
        token: 'moderator_token_123',
      );

      expect(loginBody.id, 1112223334);
      expect(loginBody.role, 'moderator');
      expect(loginBody.token, 'moderator_token_123');
    });

    test('Different roles', () {
      final admin = LoginBody(
        id: 1,
        role: 'admin',
        token: 'admin_token',
      );

      final moderator = LoginBody(
        id: 2,
        role: 'moderator',
        token: 'moderator_token',
      );

      final user = LoginBody(
        id: 3,
        role: 'user',
        token: 'user_token',
      );

      expect(admin.role, 'admin');
      expect(moderator.role, 'moderator');
      expect(user.role, 'user');
    });

    test('LoginBody with long token', () {
      final longToken = 'a'.padRight(500, 'b');
      final loginBody = LoginBody(
        id: 123,
        role: 'user',
        token: longToken,
      );

      expect(loginBody.token, longToken);
      expect(loginBody.token.length, 500);
    });
  });
}