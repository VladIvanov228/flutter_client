import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_program/utils/work_time_utils.dart';
import 'package:project_program/entity/data/user.dart';

void main() {
  group('WorkTimeUtils', () {
    test('formatTime', () {
      expect(WorkTimeUtils.formatTime(const TimeOfDay(hour: 9, minute: 5)), '09:05');
      expect(WorkTimeUtils.formatTime(const TimeOfDay(hour: 14, minute: 30)), '14:30');
    });

    test('formatDuration', () {
      expect(WorkTimeUtils.formatDuration(const Duration(hours: 8, minutes: 30)), '8:30');
      expect(WorkTimeUtils.formatDuration(const Duration(minutes: 5)), '0:05');
    });

    test('formatDate', () {
      expect(WorkTimeUtils.formatDate(DateTime(2025, 12, 8)), '08.12.2025');
    });

    test('formatEmployeeName', () {
      final user = User(
        id: 1,
        first_name: 'Иван',
        last_name: 'Иванов',
        patronymic: 'Иванович',
        role: 'user',
        depart_id: 1,
        company_id: 123,
        schedule_id: 1,
        password: '',
      );
      expect(WorkTimeUtils.formatEmployeeName(user), 'Иванов И.И.');

      final userNoPatronymic = User(
        id: 2,
        first_name: 'Анна',
        last_name: 'Петрова',
        patronymic: '',
        role: 'user',
        depart_id: 1,
        company_id: 123,
        schedule_id: 1,
        password: '',
      );
      expect(WorkTimeUtils.formatEmployeeName(userNoPatronymic), 'Петрова А..');
    });

    test('calculateBreakDuration', () {
      expect(WorkTimeUtils.calculateBreakDuration(const TimeOfDay(hour: 0, minute: 0)), const Duration(minutes: 0));
      expect(WorkTimeUtils.calculateBreakDuration(const TimeOfDay(hour: 12, minute: 0)), const Duration(hours: 1));
    });

    test('calculateFactBreakDuration', () {
      expect(WorkTimeUtils.calculateFactBreakDuration(null, null), const Duration(minutes: 0));
      expect(
        WorkTimeUtils.calculateFactBreakDuration(
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 12, minute: 30),
        ),
        const Duration(minutes: 30),
      );
    });

    test('calculateWorkHours', () {
      final start = const TimeOfDay(hour: 9, minute: 0);
      final end = const TimeOfDay(hour: 18, minute: 0);
      final breakDur = const Duration(hours: 1);
      expect(WorkTimeUtils.calculateWorkHours(start, end, breakDur), const Duration(hours: 8));
    });

    test('determineStatus', () {
      final planStart = const TimeOfDay(hour: 9, minute: 0);
      final factStart = const TimeOfDay(hour: 9, minute: 20); // опоздание на 20
      final planEnd = const TimeOfDay(hour: 18, minute: 0);
      final factEnd = const TimeOfDay(hour: 18, minute: 0);
      final planBreak = const Duration(hours: 1);
      final factBreak = const Duration(hours: 1);

      expect(
        WorkTimeUtils.determineStatus(planStart, factStart, planEnd, factEnd, planBreak, factBreak),
        'ненорм',
      );

      final goodStart = const TimeOfDay(hour: 9, minute: 0);
      expect(
        WorkTimeUtils.determineStatus(goodStart, goodStart, planEnd, factEnd, planBreak, factBreak),
        'норм',
      );
    });

    test('generateNote', () {
      final plan = const TimeOfDay(hour: 9, minute: 0);
      final factLate = const TimeOfDay(hour: 9, minute: 15);
      expect(WorkTimeUtils.generateNote(plan, factLate, plan, plan), 'Опоздание на 15');

      final factEarly = const TimeOfDay(hour: 8, minute: 50);
      expect(WorkTimeUtils.generateNote(plan, factEarly, plan, plan), 'Пришел на 10 раньше');

      expect(WorkTimeUtils.generateNote(plan, plan, plan, plan), 'Выполнено в ср');
    });

    test('getCurrentDate', () {
      // Просто проверим, что не падает и содержит год
      final dateStr = WorkTimeUtils.getCurrentDate();
      expect(dateStr, contains('2025')); 
      expect(dateStr, contains('г.'));
    });
  });
}