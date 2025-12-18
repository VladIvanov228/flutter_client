import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_program/entity/data/journal_item.dart';

void main() {
  group('JournalItem', () {
    test('parseTime should parse valid time string', () {
      final time = JournalItem.parseTime('09:30');
      expect(time.hour, 9);
      expect(time.minute, 30);
    });

    test('parseTime should parse time with leading zeros', () {
      final time = JournalItem.parseTime('05:05');
      expect(time.hour, 5);
      expect(time.minute, 5);
    });

    test('fromJson should create JournalItem from JSON', () {
      final json = {
        'id': 1,
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause': '13:00',
        'status': 'worked',
        'note': 'Test note',
        'user_inn': 1234567890,
        'user_company_ogrn': 9876543210987,
        'user_schedule_id': 1,
        'date': '2025-12-19'
      };

      final item = JournalItem.fromJson(json);

      expect(item.id, 1);
      expect(item.start.hour, 9);
      expect(item.start.minute, 0);
      expect(item.end.hour, 18);
      expect(item.end.minute, 0);
      expect(item.pause.hour, 13);
      expect(item.pause.minute, 0);
      expect(item.status, 'worked');
      expect(item.note, 'Test note');
      expect(item.user_inn, 1234567890);
      expect(item.company_id, 9876543210987);
      expect(item.schedule_id, 1);
      expect(item.date.year, 2025);
      expect(item.date.month, 12);
      expect(item.date.day, 19);
    });

    test('fromJson should handle null id', () {
      final json = {
        'id': null,
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause': '13:00',
        'status': 'worked',
        'note': 'Test note',
        'user_inn': 1234567890,
        'user_company_ogrn': 9876543210987,
        'user_schedule_id': 1,
        'date': '2025-12-19'
      };

      final item = JournalItem.fromJson(json);
      expect(item.id, 0); // Should default to 0
    });

    test('toJson should convert JournalItem to JSON', () {
      final item = JournalItem(
        id: 1,
        start: const TimeOfDay(hour: 9, minute: 5),
        pause: const TimeOfDay(hour: 13, minute: 30),
        end: const TimeOfDay(hour: 18, minute: 0),
        status: 'worked',
        note: 'Test note',
        user_inn: 1234567890,
        company_id: 9876543210987,
        schedule_id: 1,
        date: DateTime(2025, 12, 19),
      );

      final json = item.toJson();

      expect(json['id'], 1);
      expect(json['start'], '09:05');
      expect(json['pause'], '13:30');
      expect(json['stop'], '18:00');
      expect(json['status'], 'worked');
      expect(json['note'], 'Test note');
      expect(json['user_inn'], 1234567890);
      expect(json['user_company_ogrn'], 9876543210987);
      expect(json['user_schedule_id'], 1);
      expect(json['date'], contains('2025-12-19'));
    });

    test('Constructor should initialize all fields correctly', () {
      final item = JournalItem(
        id: 100,
        start: const TimeOfDay(hour: 8, minute: 30),
        pause: const TimeOfDay(hour: 12, minute: 0),
        end: const TimeOfDay(hour: 17, minute: 0),
        status: 'pending',
        note: '',
        user_inn: 1112223334,
        company_id: 5556667778889,
        schedule_id: 2,
        date: DateTime.now(),
      );

      expect(item.id, 100);
      expect(item.start.hour, 8);
      expect(item.start.minute, 30);
      expect(item.status, 'pending');
      expect(item.note, '');
      expect(item.user_inn, 1112223334);
      expect(item.company_id, 5556667778889);
      expect(item.schedule_id, 2);
    });
  });
}