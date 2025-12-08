import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_program/entity/data/user.dart';

//Файл для тестирования с публичными методами из managerPage.dart, т.к там приватные методы

class WorkTimeUtils {
  // Форматирование времени
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Форматирование длительности (часы:минуты)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  // Форматирование даты ДД.ММ.ГГГГ
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  // Форматирование ФИО как "Иванов И.И."
  static String formatEmployeeName(User user) {
    final lastName = user.last_name;
    final firstNameInitial = user.first_name.isNotEmpty ? user.first_name[0] : '';
    final patronymicInitial = user.patronymic.isNotEmpty ? user.patronymic[0] : '';
    return '$lastName $firstNameInitial.$patronymicInitial.';
  }

  // Расчёт плановой длительности перерыва
  static Duration calculateBreakDuration(TimeOfDay pause) {
    if (pause.hour == 0 && pause.minute == 0) {
      return const Duration(minutes: 0);
    }
    return const Duration(hours: 1);
  }

  // Расчёт фактической длительности перерыва
  static Duration calculateFactBreakDuration(TimeOfDay? breakStart, TimeOfDay? breakEnd) {
    if (breakStart == null ||
        breakEnd == null ||
        (breakStart.hour == 0 && breakStart.minute == 0) ||
        (breakEnd.hour == 0 && breakEnd.minute == 0)) {
      return const Duration(minutes: 0);
    }
    final startMinutes = breakStart.hour * 60 + breakStart.minute;
    final endMinutes = breakEnd.hour * 60 + breakEnd.minute;
    final diff = endMinutes - startMinutes;
    return Duration(minutes: diff > 0 ? diff : 0);
  }

  // Расчёт отработанных часов
  static Duration calculateWorkHours(TimeOfDay start, TimeOfDay end, Duration breakDuration) {
    if (end.hour == 0 && end.minute == 0) {
      return const Duration(minutes: 0);
    }
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final totalMinutes = endMinutes - startMinutes - breakDuration.inMinutes;
    return Duration(minutes: totalMinutes > 0 ? totalMinutes : 0);
  }

  // Определение статуса (норм/ненорм)
  static String determineStatus(
    TimeOfDay planStart,
    TimeOfDay factStart,
    TimeOfDay planEnd,
    TimeOfDay factEnd,
    Duration planBreak,
    Duration factBreak,
  ) {
    final startDiff = (factStart.hour * 60 + factStart.minute) - (planStart.hour * 60 + planStart.minute);
    if (startDiff > 15) return 'ненорм';

    final endDiff = (planEnd.hour * 60 + planEnd.minute) - (factEnd.hour * 60 + factEnd.minute);
    if (endDiff > 15) return 'ненорм';

    final breakDiff = (factBreak.inMinutes - planBreak.inMinutes).abs();
    if (breakDiff > 30) return 'ненорм';

    return 'норм';
  }

  // Генерация заметки
  static String generateNote(TimeOfDay planStart, TimeOfDay factStart, TimeOfDay planEnd, TimeOfDay factEnd) {
    final startDiff = (factStart.hour * 60 + factStart.minute) - (planStart.hour * 60 + planStart.minute);
    if (startDiff > 0) {
      return 'Опоздание на $startDiff';
    } else if (startDiff < 0) {
      return 'Пришел на ${startDiff.abs()} раньше';
    } else {
      return 'Выполнено в ср';
    }
  }

  // Текущая дата в формате "понедельник, 8 декабря 2025 г."
  static String getCurrentDate() {
    final now = DateTime.now();
    final weekdays = ['понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'];
    final months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday, ${now.day} $month ${now.year} г.';
  }
}