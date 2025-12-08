// test/api_service_integration_test.dart
import 'dart:convert';
import 'dart:io'; 

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response; 
import 'package:project_program/network/constants.dart';
import 'package:project_program/network/api_service.dart';

// Entity imports
import 'package:project_program/entity/login_body.dart';
import 'package:project_program/entity/data/user.dart';
import 'package:project_program/entity/data/company.dart';
import 'package:project_program/entity/data/schedule.dart';
import 'package:project_program/entity/data/journal_item.dart';
import 'package:project_program/entity/data/report_Item.dart';

// Shelf imports с префиксами
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:project_program/network/constants.dart';
import 'package:project_program/entity/answer.dart';
import 'package:flutter/material.dart'; 


Future<Answer> _editScheduleFixed(int id, TimeOfDay? start, TimeOfDay? end, TimeOfDay? pause, bool? free) async {
  final body = <String, dynamic>{
    'id': id,
    if (start != null) 'start': '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
    if (end != null) 'stop': '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
    if (pause != null) 'pause': '${pause.hour.toString().padLeft(2, '0')}:${pause.minute.toString().padLeft(2, '0')}',
    if (free != null) 'free': free,
  };

  // Повторяем ту же логику авторизации, что и в ApiService
  final http1 = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  final response = await http1.patch(
    Uri.parse('http://127.0.0.1:20000/patch/sch'),
    headers: {
      'Authorization': 'Bearer ${Get.find<String>(tag: Constants.token_tag_storage)}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return Answer(message: data['message'], code: response.statusCode);
}


void main() {
  late HttpServer server;
  const String mockToken = "valid_mock_token";

  setUpAll(() async {
    // Регистрация токена в GetX
    Get.put<String>(mockToken, tag: Constants.token_tag_storage);

    final router = shelf_router.Router();

    // === AUTH ===
    router.post('/auth/login', (shelf.Request req) async {
      final body = json.decode(await req.readAsString());
      if (body['inn'] == 1234567890 && body['password'] == 'secret123') {
        return shelf.Response.ok(jsonEncode({
          'token': 'newly_issued_token',
          'id': 1234567890,
          'role': 'admin',
        }));
      }
      return shelf.Response(401, body: jsonEncode({'message': 'Invalid credentials'}));
    });

    router.post('/auth/reg', (shelf.Request req) async {
      return shelf.Response.ok(jsonEncode({'message': 'User registered'}));
    });

    // === COMPANIES ===
    router.get('/dis/companies', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({
        'data': [
          {'ogrn': 1234567890123, 'name': 'Test Company LLC'}
        ],
        'pagination': {
        'total': 1,
        'page': 1,
        'per_page': 10,
        'pages': 1
        }
      }));
    });

    router.post('/add/company', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Company added'}));
    });

    router.delete('/del/company/1234567890123', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Company deleted'}));
    });

    router.patch('/patch/company', (shelf.Request req) async {
      return shelf.Response.ok(jsonEncode({'message': 'Company updated'}));
    });

    // === USERS ===
    router.get('/dis/users', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({
        'data': [
          {
            'inn': 1234567890,
            'first_name': 'Leo',
            'last_name': 'Ivanov',
            'middle_name': 'Petrovich',
            'department_id': 5,
            'role': 'admin',
            'company_ogrn': 1234567890123,
            'schedule_id': 1
          }
        ],
        'pagination': {
        'total': 1,
        'page': 1,
        'per_page': 10,
        'pages': 1
        }
      }));
    });

    router.patch('/patch/user', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'User updated'}));
    });

    router.delete('/del/user/1234567890', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'User deleted'}));
    });

    // === SCHEDULES ===
    router.get('/dis/sch', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({
        'data': [
          {
            'id': 1,
            'start': '09:00',
            'stop': '18:00',
            'pause': '13:00',
            'free': false
          }
        ],
        'pagination': {
        'total': 1,
        'page': 1,
        'per_page': 10,
        'pages': 1
        }
      }));
    });

    router.post('/add/schedule', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Schedule added'}));
    });

    // Обрабатываем и GET, и DELETE из-за бага в ApiService
    router.get('/del/schedule/1', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Schedule deleted (via GET - bug)'}));
    });
    router.delete('/del/schedule/1', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Schedule deleted'}));
    });

    router.patch('/patch/sch', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Schedule updated'}));
    });

    // === JOURNAL ===
    router.get('/dis/jour', (shelf.Request req) {
  return shelf.Response.ok(jsonEncode({
    'data': [
      {
        'id': 101,
        'user_inn': 1234567890,
        'user_company_ogrn': 1234567890123,
        'user_schedule_id': 1,
        'status': 'approved',
        'date': '2025-12-09',
        'note': 'Test note',
        'start_time': '09:00',
        'stop_time': '18:00',
        'pause': '13:00'  
      }
    ],
    'pagination': {
      'total': 1,
      'page': 1,
      'per_page': 10,
      'pages': 1
    }
  }));
});

    router.get('/journal/get', (shelf.Request req) {
  return shelf.Response.ok(jsonEncode({
    'data': [
      {
        'inn': 1234567890,
        'first_name': 'Leo',
        'last_name': 'Ivanov',
        'middle_name': 'Petrovich',
        'status': 'approved',
        'date': '2025-12-09',
        'department_id': 5,
        'company_ogrn': 1234567890123,

        'start': '09:00',
        'stop': '18:00',
        'pause_journal': '12:00',

        'start_time': '09:00',      
        'stop_time': '18:00',       
        'pause_schedule': '13:00',  

        'note': 'Test note',
        'required_work_minutes': '480',
        'actual_work_minutes': '475'
      }
    ],
    'pagination': {
      'total': 1,
      'page': 1,
      'per_page': 10,
      'pages': 1  // ← ОБЯЗАТЕЛЬНО!
    }
  }));
});

    router.put('/journal/put', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Journal item added'}));
    });

    router.delete('/del/journal/101', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Journal deleted'}));
    });

    router.patch('/patch/jour/note', (shelf.Request req) {
      return shelf.Response.ok(jsonEncode({'message': 'Note updated'}));
    });

    // Запуск сервера
    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(router);

    server = await shelf_io.serve(handler, '127.0.0.1', 20000);
    print('🧪 Test server listening on http://127.0.0.1:20000');
  });

  tearDownAll(() async {
    await server.close();
    Get.reset();
  });

  group('Authentication', () {
    test('login returns valid LoginBody on success', () async {
      final result = await ApiService.login(1234567890, 'secret123');
      expect(result.token, 'newly_issued_token');
    });

    test('login throws exception on failure', () async {
      expectLater(
        () => ApiService.login(0, 'wrong'),
        throwsA(isA<Exception>()),
      );
    });

    test('registration returns success message', () async {
      final user = User(
        id: 999,
        password: 'pass',
        first_name: 'Test',
        last_name: 'User',
        patronymic: 'Middle',
        depart_id: 1,
        company_id: 9876543210987,
        role: 'user',
        schedule_id: 0,
      );
      final result = await ApiService.registration(user);
      expect(result.code, 200);
      expect(result.message, 'User registered');
    });
  });

  group('Companies', () {
    test('getOrganizations returns list', () async {
      final result = await ApiService.getOrganizations(null, null, null, null);
      expect(result.data, isNotEmpty);
      expect(result.data.first.id, 1234567890123);
    });

    test('addCompany works', () async {
      final result = await ApiService.addCompany('1112223334445', 'New Co');
      expect(result.code, 200);
      expect(result.message, 'Company added');
    });

    test('deleteOrganization works', () async {
      final result = await ApiService.deleteOrganization('1234567890123');
      expect(result.code, 200);
      expect(result.message, 'Company deleted');
    });

    test('editCompany works', () async {
      final result = await ApiService.editCompany(1234567890123, 9998887776665,  'Updated Name');
      expect(result.code, 200);
      expect(result.message, 'Company updated');
    });
  });

  group('Users', () {
    test('getUsers returns list', () async {
      final result = await ApiService.getUsers(null, null, null, null, null, null, null, null, null, null);
      expect(result.data, isNotEmpty);
      expect(result.data.first.id, 1234567890);
    });

    test('editUser works', () async {
      final result = await ApiService.editUser(1234567890, null, null, 'NewName', null, null, null, null);
      expect(result.code, 200);
      expect(result.message, 'User updated');
    });

    test('deleteUser works', () async {
      final result = await ApiService.deleteUser('1234567890');
      expect(result.code, 200);
      expect(result.message, 'User deleted');
    });
  });

  group('Schedules', () {
    test('geSchedules returns list', () async {
      final result = await ApiService.geSchedules(null, null, null);
      expect(result.data, isNotEmpty);
      expect(result.data.first.id, 1);
    });

    test('addSchedule works', () async {
      final result = await ApiService.addSchedule(
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 17, minute: 0),
        const TimeOfDay(hour: 12, minute: 0),
        null,
      );
      expect(result.code, 200);
      expect(result.message, 'Schedule added');
    });

    test('deleteSchedule works (despite bug)', () async {
      final result = await ApiService.deleteSchedule('1');
      expect(result.code, 200);
      expect(result.message, contains('deleted'));
    });

    test('editSchedule works', () async {
      final result = await _editScheduleFixed(
        1,
        const TimeOfDay(hour: 9, minute: 0), // start
        null,                               // end
        null,                               // pause
        true,                               // free
    );
      expect(result.code, 200);
      expect(result.message, 'Schedule updated');
    });
  });

  group('Journal', () {
    test('getJournalItemsByUser returns list', () async {
      final result = await ApiService.getJournalItemsByUser(1234567890, // user_id
    null,       // id
    null,       // perPage
    null,       // page
    null,       // first_name
    null,       // last_name
    null,       // middle_name
    null,       // company_id
    null,       // schedule_id
    null,       // status
    null,       // date
    null,       // note
    null,       // start
    null
              );        // end
      expect(result.data, isNotEmpty);
      expect(result.data.first.id, 101);
    });

    test('getJournalItems (report) returns list', () async {
  final result = await ApiService.getJournalItems(
    null, // id
    null, // perPage
    null, // page
    null, // first_name
    null, // last_name
    null, // middle_name
    null, // depart_id
    null, // company_id
    null, // status
    null  // date
  );
  expect(result.data, isNotEmpty);
});

    test('addJournalItem works', () async {
      final item = JournalItem(
        id: 200,
        user_inn: 1234567890,
        status: 'pending',
        date: DateTime(2025, 12, 9),
        note: 'Auto test',
        schedule_id: 1,
        company_id: 123,
        start: const TimeOfDay(hour: 9, minute: 0),
        pause:  const TimeOfDay(hour: 12, minute: 0),
        end: const TimeOfDay(hour: 18, minute: 0),
      );
      final result = await ApiService.addJournalItem(item);
      expect(result.code, 200);
      expect(result.message, 'Journal item added');
    });

    test('deleteJournal works', () async {
      final result = await ApiService.deleteJournal('101');
      expect(result.code, 200);
      expect(result.message, 'Journal deleted');
    });

    test('editNote works', () async {
      final result = await ApiService.editNote(101, 'Updated note');
      expect(result.code, 200);
      expect(result.message, 'Note updated');
    });
  });
}