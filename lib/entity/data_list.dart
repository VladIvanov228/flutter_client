
import 'dart:convert';

import 'package:project_program/entity/data/company.dart';
import 'package:project_program/entity/data/journal_item.dart';
import 'package:project_program/entity/data/report_Item.dart';
import 'package:project_program/entity/pagination.dart';
import 'package:project_program/entity/data/user.dart';

import 'data/schedule.dart';

class DataList<T> {

  late Pagination pagination;
  late int count;
  late List<T> data;

  DataList({required this.pagination, required this.data, required this.count});

  factory DataList.fromJson(Map<String, dynamic> json) {
    return DataList<T>(
      pagination: Pagination.fromJson(json['pagination']),
      count: json['count'] ?? 0,
      data: _parseData(json['data'] ?? json['schedules'] ?? json['entries'], T) as List<T>
    );
  }

  static List _parseData(List<dynamic> source, Type type) {
    print(type);
    if(type==User) {
      return source.map((json) => User.fromJson(json)).toList();
    } else if(type==Company) {
      return source.map((json) => Company.fromJson(json)).toList();
    } else if(type==JournalItem) {
      return source.map((json) => JournalItem.fromJson(json)).toList();
    } else if(type==Schedule) {
      return source.map((json) => Schedule.fromJson(json)).toList();
    } else if(type==ReportItem) {
      return source.map((json) => ReportItem.fromJson(json)).toList();
    }
    return [];
  }
}