
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class JournalItem {

  late int id;
  late TimeOfDay start;
  late TimeOfDay pause;
  late TimeOfDay end;
  late String status;
  late String note;
  late int user_inn;
  late int company_id;
  late int schedule_id;
  late DateTime date;

  JournalItem({
    required this.id,
    required this.start,
    required this.pause,
    required this.end,
    required this.status,
    required this.note,
    required this.schedule_id,
    required this.company_id,
    required this.user_inn,
    required this.date
  });

  factory JournalItem.fromJson(Map<String, dynamic> json) {
    return JournalItem(
      id: json['id'] ?? 0,
      start: parseTime(json['start_time']),
      end: parseTime(json['stop_time']),
      pause: parseTime(json['pause']),
      status: json['status'],
      note: json['note'],
      user_inn: json['user_inn'],
      company_id: json['user_company_ogrn'],
      schedule_id: json['user_schedule_id'],
      date: DateTime.parse(json['date'])
    );
  }
  static TimeOfDay parseTime(String s) {
    var t = s.split(":");
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': '${sprintf('%02d',[start.hour])}:${sprintf('%02d',[start.minute])}',
      'pause': '${sprintf('%02d',[pause.hour])}:${sprintf('%02d',[pause.minute])}',
      'stop': '${sprintf('%02d',[end.hour])}:${sprintf('%02d',[end.minute])}',
      'status': status,
      'note': note,
      'user_inn': user_inn,
      'user_company_ogrn': company_id,
      'user_schedule_id': schedule_id,
      'date': date.toString(),
    };
  }

}