
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class ReportItem {

  late TimeOfDay start;
  late TimeOfDay start_schedule;
  late TimeOfDay pause;
  late TimeOfDay pause_schedule;
  late TimeOfDay end;
  late TimeOfDay end_schedule;
  late String status;
  late String note;
  late String first_name;
  late String last_name;
  late String patronymic;
  late int user_inn;
  late int company_id;
  late int depart_id;
  late DateTime date;
  late int required;
  late int actual;

  ReportItem({
    required this.start,
    required this.pause,
    required this.end,
    required this.status,
    required this.note,
    required this.company_id,
    required this.user_inn,
    required this.date,
    required this.first_name,
    required this.last_name,
    required this.patronymic,
    required this.depart_id,
    required this.start_schedule,
    required this.pause_schedule,
    required this.end_schedule,
    required this.required,
    required this.actual
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    return ReportItem(
        start: parseTime(json['start']),
        end: parseTime(json['stop']),
        pause: parseTime(json['pause_journal']),
        start_schedule: parseTime(json['start_time']),
        end_schedule: parseTime(json['stop_time']),
        pause_schedule: parseTime(json['pause_schedule']),
        status: json['status'],
        note: json['note'],
        user_inn: json['inn'],
        company_id: json['company_ogrn'],
        date: DateTime.parse(json['date']),
        first_name: json['first_name'],
        last_name: json['last_name'],
        patronymic: json['middle_name'],
        depart_id: int.parse(json['department_id'].toString()),
        required: double.parse(json['required_work_minutes'].toString()).round(),
        actual: double.parse(json['actual_work_minutes'].toString()).round(),
    );
  }
  static TimeOfDay parseTime(String s) {
    var t = s.split(":");
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }


}