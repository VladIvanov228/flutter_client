import 'package:flutter_test/flutter_test.dart';
import 'package:project_program/entity/data/user.dart';

void main() {
  group('User', () {
    test('fromJson should create User from JSON', () {
      final json = {
        'inn': '1234567890',
        'company_ogrn': '9876543210987',
        'department_id': '5',
        'schedule_id': '1',
        'first_name': 'Иван',
        'last_name': 'Иванов',
        'middle_name': 'Иванович',
        'role': 'user',
        'password': 'secret123'
      };

      final user = User.fromJson(json);

      expect(user.id, 1234567890);
      expect(user.company_id, 9876543210987);
      expect(user.depart_id, 5);
      expect(user.schedule_id, 1);
      expect(user.first_name, 'Иван');
      expect(user.last_name, 'Иванов');
      expect(user.patronymic, 'Иванович');
      expect(user.role, 'user');
      expect(user.password, 'secret123');
    });

    test('fromJson should handle numeric values', () {
      final json = {
        'inn': 1112223334,
        'company_ogrn': 5556667778889,
        'department_id': 10,
        'schedule_id': 2,
        'first_name': 'Test',
        'last_name': 'User',
        'middle_name': 'Middle',
        'role': 'admin',
        'password': 'pass123'
      };

      final user = User.fromJson(json);

      expect(user.id, 1112223334);
      expect(user.company_id, 5556667778889);
      expect(user.depart_id, 10);
      expect(user.schedule_id, 2);
      expect(user.first_name, 'Test');
      expect(user.last_name, 'User');
      expect(user.patronymic, 'Middle');
      expect(user.role, 'admin');
      expect(user.password, 'pass123');
    });

    test('fromJson should handle missing password', () {
      final json = {
        'inn': '1234567890',
        'company_ogrn': '9876543210987',
        'department_id': '5',
        'schedule_id': '1',
        'first_name': 'Иван',
        'last_name': 'Иванов',
        'middle_name': 'Иванович',
        'role': 'user'
        // password intentionally omitted
      };

      final user = User.fromJson(json);
      expect(user.password, ""); // Should default to empty string
    });

    test('Constructor should initialize all fields', () {
      final user = User(
        id: 9998887776,
        company_id: 1112223334445,
        depart_id: 3,
        schedule_id: 4,
        first_name: 'Алексей',
        last_name: 'Сидоров',
        patronymic: 'Петрович',
        role: 'moderator',
        password: 'strongPassword!123',
      );

      expect(user.id, 9998887776);
      expect(user.company_id, 1112223334445);
      expect(user.depart_id, 3);
      expect(user.schedule_id, 4);
      expect(user.first_name, 'Алексей');
      expect(user.last_name, 'Сидоров');
      expect(user.patronymic, 'Петрович');
      expect(user.role, 'moderator');
      expect(user.password, 'strongPassword!123');
    });

    test('User with empty patronymic', () {
      final user = User(
        id: 123,
        company_id: 456,
        depart_id: 1,
        schedule_id: 1,
        first_name: 'John',
        last_name: 'Doe',
        patronymic: '', // Empty patronymic
        role: 'user',
        password: 'password',
      );

      expect(user.patronymic, '');
      expect(user.first_name, 'John');
      expect(user.last_name, 'Doe');
      expect(user.role, 'user');
    });

    test('Different roles', () {
      final admin = User(
        id: 1,
        company_id: 100,
        depart_id: 1,
        schedule_id: 1,
        first_name: 'Admin',
        last_name: 'User',
        patronymic: '',
        role: 'admin',
        password: 'admin123',
      );

      final moderator = User(
        id: 2,
        company_id: 100,
        depart_id: 2,
        schedule_id: 2,
        first_name: 'Moderator',
        last_name: 'User',
        patronymic: '',
        role: 'moderator',
        password: 'mod123',
      );

      final regular = User(
        id: 3,
        company_id: 100,
        depart_id: 2,
        schedule_id: 2,
        first_name: 'Regular',
        last_name: 'User',
        patronymic: '',
        role: 'user',
        password: 'user123',
      );

      expect(admin.role, 'admin');
      expect(moderator.role, 'moderator');
      expect(regular.role, 'user');
    });
  });
}