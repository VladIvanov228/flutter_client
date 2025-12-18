import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_program/entity/data/report_Item.dart';

void main() {
  group('ReportItem', () {
    test('fromJson should create ReportItem from JSON', () {
      final json = {
        'start': '08:30',
        'stop': '17:30',
        'pause_journal': '12:00',
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause_schedule': '13:00',
        'status': 'норм',
        'note': 'Работал хорошо',
        'inn': 1234567890,
        'company_ogrn': 9876543210987,
        'date': '2025-12-19',
        'first_name': 'Иван',
        'last_name': 'Иванов',
        'middle_name': 'Иванович',
        'department_id': '5',
        'required_work_minutes': '540',
        'actual_work_minutes': '530'
      };

      final item = ReportItem.fromJson(json);

      expect(item.start.hour, 8);
      expect(item.start.minute, 30);
      expect(item.end.hour, 17);
      expect(item.end.minute, 30);
      expect(item.pause.hour, 12);
      expect(item.pause.minute, 0);
      expect(item.start_schedule.hour, 9);
      expect(item.start_schedule.minute, 0);
      expect(item.end_schedule.hour, 18);
      expect(item.end_schedule.minute, 0);
      expect(item.pause_schedule.hour, 13);
      expect(item.pause_schedule.minute, 0);
      expect(item.status, 'норм');
      expect(item.note, 'Работал хорошо');
      expect(item.user_inn, 1234567890);
      expect(item.company_id, 9876543210987);
      expect(item.date.year, 2025);
      expect(item.date.month, 12);
      expect(item.date.day, 19);
      expect(item.first_name, 'Иван');
      expect(item.last_name, 'Иванов');
      expect(item.patronymic, 'Иванович');
      expect(item.depart_id, 5);
      expect(item.required, 540);
      expect(item.actual, 530);
    });

    test('fromJson should handle string and numeric department_id', () {
      // Test with string department_id
      final json1 = {
        'start': '09:00',
        'stop': '18:00',
        'pause_journal': '13:00',
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause_schedule': '13:00',
        'status': 'норм',
        'note': '',
        'inn': 123,
        'company_ogrn': 456,
        'date': '2025-12-19',
        'first_name': 'Test',
        'last_name': 'User',
        'middle_name': 'Middle',
        'department_id': '10',
        'required_work_minutes': '480',
        'actual_work_minutes': '480'
      };

      final item1 = ReportItem.fromJson(json1);
      expect(item1.depart_id, 10);

      // Test with numeric department_id
      final json2 = {
        'start': '09:00',
        'stop': '18:00',
        'pause_journal': '13:00',
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause_schedule': '13:00',
        'status': 'норм',
        'note': '',
        'inn': 123,
        'company_ogrn': 456,
        'date': '2025-12-19',
        'first_name': 'Test',
        'last_name': 'User',
        'middle_name': 'Middle',
        'department_id': 15,
        'required_work_minutes': '480',
        'actual_work_minutes': '480'
      };

      final item2 = ReportItem.fromJson(json2);
      expect(item2.depart_id, 15);
    });

    test('parseTime should handle time parsing for ReportItem', () {
      final time = ReportItem.parseTime('14:45');
      expect(time.hour, 14);
      expect(time.minute, 45);
    });

    test('Constructor should initialize all fields correctly', () {
      final item = ReportItem(
        start: const TimeOfDay(hour: 8, minute: 45),
        pause: const TimeOfDay(hour: 12, minute: 30),
        end: const TimeOfDay(hour: 17, minute: 15),
        status: 'норм',
        note: 'Тестовая заметка',
        company_id: 1112223334445,
        user_inn: 1234567890,
        date: DateTime(2025, 12, 19),
        first_name: 'Петр',
        last_name: 'Петров',
        patronymic: 'Петрович',
        depart_id: 3,
        start_schedule: const TimeOfDay(hour: 9, minute: 0),
        pause_schedule: const TimeOfDay(hour: 13, minute: 0),
        end_schedule: const TimeOfDay(hour: 18, minute: 0),
        required: 480,
        actual: 475,
      );

      expect(item.start.hour, 8);
      expect(item.start.minute, 45);
      expect(item.pause.hour, 12);
      expect(item.pause.minute, 30);
      expect(item.end.hour, 17);
      expect(item.end.minute, 15);
      expect(item.status, 'норм');
      expect(item.note, 'Тестовая заметка');
      expect(item.company_id, 1112223334445);
      expect(item.user_inn, 1234567890);
      expect(item.date.year, 2025);
      expect(item.first_name, 'Петр');
      expect(item.last_name, 'Петров');
      expect(item.patronymic, 'Петрович');
      expect(item.depart_id, 3);
      expect(item.start_schedule.hour, 9);
      expect(item.end_schedule.hour, 18);
      expect(item.pause_schedule.hour, 13);
      expect(item.required, 480);
      expect(item.actual, 475);
    });

    test('fromJson should handle double values for minutes', () {
      final json = {
        'start': '09:00',
        'stop': '18:00',
        'pause_journal': '13:00',
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause_schedule': '13:00',
        'status': 'норм',
        'note': '',
        'inn': 123,
        'company_ogrn': 456,
        'date': '2025-12-19',
        'first_name': 'Test',
        'last_name': 'User',
        'middle_name': 'Middle',
        'department_id': '5',
        'required_work_minutes': 540.5,
        'actual_work_minutes': 530.75
      };

      final item = ReportItem.fromJson(json);
      expect(item.required, 541); // Rounded from 540.5
      expect(item.actual, 531); // Rounded from 530.75
    });
  });
}