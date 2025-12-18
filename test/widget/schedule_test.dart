import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_program/entity/data/schedule.dart';

void main() {
  group('Schedule', () {
    test('fromJson should create Schedule from JSON', () {
      final json = {
        'id': 1,
        'start': '08:00',
        'stop': '17:00',
        'pause': '12:00',
        'free': true
      };

      final schedule = Schedule.fromJson(json);

      expect(schedule.id, 1);
      expect(schedule.start.hour, 8);
      expect(schedule.start.minute, 0);
      expect(schedule.end.hour, 17);
      expect(schedule.end.minute, 0);
      expect(schedule.pause.hour, 12);
      expect(schedule.pause.minute, 0);
      expect(schedule.free, true);
    });

    test('fromJson should handle boolean values', () {
      // Test with boolean true
      final json1 = {
        'id': 2,
        'start': '09:00',
        'stop': '18:00',
        'pause': '13:00',
        'free': true
      };

      final schedule1 = Schedule.fromJson(json1);
      expect(schedule1.free, true);

      // Test with boolean false
      final json2 = {
        'id': 3,
        'start': '10:00',
        'stop': '19:00',
        'pause': '14:00',
        'free': false
      };

      final schedule2 = Schedule.fromJson(json2);
      expect(schedule2.free, false);

      // Test with string 'true'
      final json3 = {
        'id': 4,
        'start': '09:00',
        'stop': '18:00',
        'pause': '13:00',
        'free': 'true'
      };

      final schedule3 = Schedule.fromJson(json3);
      expect(schedule3.free, true); // String 'true' should convert to bool true

      // Test with string 'false'
      final json4 = {
        'id': 5,
        'start': '09:00',
        'stop': '18:00',
        'pause': '13:00',
        'free': 'false'
      };

      final schedule4 = Schedule.fromJson(json4);
      expect(schedule4.free, false);
    });

    test('parseTime should parse time correctly', () {
      final time = Schedule.parseTime('23:59');
      expect(time.hour, 23);
      expect(time.minute, 59);

      final time2 = Schedule.parseTime('00:00');
      expect(time2.hour, 0);
      expect(time2.minute, 0);

      final time3 = Schedule.parseTime('12:34');
      expect(time3.hour, 12);
      expect(time3.minute, 34);
    });

    test('Constructor should initialize all fields', () {
      final schedule = Schedule(
        id: 100,
        start: const TimeOfDay(hour: 7, minute: 30),
        pause: const TimeOfDay(hour: 11, minute: 45),
        end: const TimeOfDay(hour: 16, minute: 15),
        free: false,
      );

      expect(schedule.id, 100);
      expect(schedule.start.hour, 7);
      expect(schedule.start.minute, 30);
      expect(schedule.pause.hour, 11);
      expect(schedule.pause.minute, 45);
      expect(schedule.end.hour, 16);
      expect(schedule.end.minute, 15);
      expect(schedule.free, false);
    });

    test('Schedule with free day', () {
      final schedule = Schedule(
        id: 999,
        start: const TimeOfDay(hour: 0, minute: 0),
        pause: const TimeOfDay(hour: 0, minute: 0),
        end: const TimeOfDay(hour: 0, minute: 0),
        free: true,
      );

      expect(schedule.id, 999);
      expect(schedule.start.hour, 0);
      expect(schedule.end.hour, 0);
      expect(schedule.pause.hour, 0);
      expect(schedule.free, true);
    });
  });
}