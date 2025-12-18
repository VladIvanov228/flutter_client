import 'package:flutter_test/flutter_test.dart';
import 'package:project_program/entity/data_list.dart';
import 'package:project_program/entity/pagination.dart';
import 'package:project_program/entity/data/user.dart';
import 'package:project_program/entity/data/company.dart';
import 'package:project_program/entity/data/journal_item.dart';
import 'package:project_program/entity/data/schedule.dart';
import 'package:project_program/entity/data/report_Item.dart';

void main() {
  group('DataList', () {
    test('fromJson should parse User list', () {
      final json = {
        'data': [
          {
            'inn': '1234567890',
            'company_ogrn': '9876543210987',
            'department_id': '5',
            'schedule_id': '1',
            'first_name': 'Иван',
            'last_name': 'Иванов',
            'middle_name': 'Иванович',
            'role': 'user'
          }
        ],
        'pagination': {
          'per_page': 10,
          'total': 100,
          'page': 1,
          'pages': 10
        },
        'count': 1
      };

      final dataList = DataList<User>.fromJson(json);

      expect(dataList.data.length, 1);
      expect(dataList.data.first, isA<User>());
      expect(dataList.data.first.id, 1234567890);
      expect(dataList.data.first.first_name, 'Иван');
      expect(dataList.count, 1);
      expect(dataList.pagination.per_page, 10);
      expect(dataList.pagination.total, 100);
      expect(dataList.pagination.page, 1);
      expect(dataList.pagination.pages, 10);
    });

    test('fromJson should parse Company list', () {
      final json = {
        'data': [
          {
            'ogrn': '1234567890123',
            'name': 'Test Company LLC'
          }
        ],
        'pagination': {
          'per_page': 10,
          'total': 50,
          'page': 1,
          'pages': 5
        },
        'count': 1
      };

      final dataList = DataList<Company>.fromJson(json);

      expect(dataList.data.length, 1);
      expect(dataList.data.first, isA<Company>());
      expect(dataList.data.first.id, 1234567890123);
      expect(dataList.data.first.name, 'Test Company LLC');
      expect(dataList.count, 1);
    });

    test('fromJson should parse JournalItem list', () {
      final json = {
        'data': [
          {
            'id': 101,
            'user_inn': 1234567890,
            'user_company_ogrn': 9876543210987,
            'user_schedule_id': 1,
            'status': 'approved',
            'date': '2025-12-19',
            'note': 'Test note',
            'start_time': '09:00',
            'stop_time': '18:00',
            'pause': '13:00'
          }
        ],
        'pagination': {
          'per_page': 10,
          'total': 25,
          'page': 1,
          'pages': 3
        },
        'count': 1
      };

      final dataList = DataList<JournalItem>.fromJson(json);

      expect(dataList.data.length, 1);
      expect(dataList.data.first, isA<JournalItem>());
      expect(dataList.data.first.id, 101);
      expect(dataList.data.first.status, 'approved');
      expect(dataList.data.first.start.hour, 9);
      expect(dataList.count, 1);
    });

    test('fromJson should parse Schedule list using schedules key', () {
      final json = {
        'schedules': [
          {
            'id': 1,
            'start': '09:00',
            'stop': '18:00',
            'pause': '13:00',
            'free': false
          }
        ],
        'pagination': {
          'per_page': 10,
          'total': 15,
          'page': 1,
          'pages': 2
        },
        'count': 1
      };

      final dataList = DataList<Schedule>.fromJson(json);

      expect(dataList.data.length, 1);
      expect(dataList.data.first, isA<Schedule>());
      expect(dataList.data.first.id, 1);
      expect(dataList.data.first.start.hour, 9);
      expect(dataList.data.first.free, false);
      expect(dataList.count, 1);
    });

    test('fromJson should parse ReportItem list', () {
      final json = {
        'data': [
          {
            'inn': 1234567890,
            'first_name': 'Иван',
            'last_name': 'Иванов',
            'middle_name': 'Иванович',
            'status': 'норм',
            'date': '2025-12-19',
            'department_id': '5',
            'company_ogrn': 9876543210987,
            'start': '08:30',
            'stop': '17:30',
            'pause_journal': '12:00',
            'start_time': '09:00',
            'stop_time': '18:00',
            'pause_schedule': '13:00',
            'note': 'Test note',
            'required_work_minutes': '540',
            'actual_work_minutes': '530'
          }
        ],
        'pagination': {
          'per_page': 10,
          'total': 30,
          'page': 1,
          'pages': 3
        },
        'count': 1
      };

      final dataList = DataList<ReportItem>.fromJson(json);

      expect(dataList.data.length, 1);
      expect(dataList.data.first, isA<ReportItem>());
      expect(dataList.data.first.user_inn, 1234567890);
      expect(dataList.data.first.last_name, 'Иванов');
      expect(dataList.data.first.status, 'норм');
      expect(dataList.data.first.required, 540);
      expect(dataList.count, 1);
    });

    test('fromJson should handle empty data array', () {
      final json = {
        'data': [],
        'pagination': {
          'per_page': 10,
          'total': 0,
          'page': 1,
          'pages': 0
        },
        'count': 0
      };

      final dataList = DataList<User>.fromJson(json);

      expect(dataList.data.length, 0);
      expect(dataList.count, 0);
      expect(dataList.pagination.total, 0);
    });

    test('fromJson should handle missing data key', () {
      final json = {
        'pagination': {
          'per_page': 10,
          'total': 0,
          'page': 1,
          'pages': 0
        },
        'count': 0
      };

      final dataList = DataList<User>.fromJson(json);

      expect(dataList.data.length, 0);
      expect(dataList.count, 0);
    });

    test('fromJson should handle null values', () {
      final json = {
        'data': null,
        'pagination': {
          'per_page': 10,
          'total': 0,
          'page': 1,
          'pages': 0
        },
        'count': null
      };

      final dataList = DataList<User>.fromJson(json);

      expect(dataList.data.length, 0);
      expect(dataList.count, 0); // Should default to 0
    });

    test('Constructor should initialize correctly', () {
      final pagination = Pagination(
        per_page: 20,
        total: 100,
        page: 2,
        pages: 5,
      );

      final users = [
        User(
          id: 1,
          company_id: 100,
          depart_id: 1,
          schedule_id: 1,
          first_name: 'Test',
          last_name: 'User',
          patronymic: '',
          role: 'user',
          password: '',
        )
      ];

      final dataList = DataList<User>(
        pagination: pagination,
        data: users,
        count: 1,
      );

      expect(dataList.pagination, pagination);
      expect(dataList.data, users);
      expect(dataList.count, 1);
    });

    test('_parseData should return empty list for unknown type', () {
      // This tests the edge case where type is not recognized
      final result = DataList._parseData([{'test': 'data'}], String);
      expect(result, isEmpty);
    });
  });
}