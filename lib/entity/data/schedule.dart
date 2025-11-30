
import 'package:flutter/material.dart';

class Schedule {

  late int id;
  late TimeOfDay start;
  late TimeOfDay pause;
  late TimeOfDay end;
  late bool free;

  Schedule({
    required this.id,
    required this.start,
    required this.pause,
    required this.end,
    required this.free
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        free: json['free'],
        start: parseTime(json['start']),
        end: parseTime(json['stop']),
        pause:parseTime(json['pause']),
    );
  }
  
  static TimeOfDay parseTime(String s) {
    var t = s.split(":");
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }
}