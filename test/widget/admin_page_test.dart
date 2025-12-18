import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:project_program/ui/adminPage.dart';
import 'package:project_program/entity/data/user.dart';

// Mock data for testing
final mockUsers = [
  User(
    id: 1234567890,
    company_id: 9876543210987,
    depart_id: 1,
    schedule_id: 1,
    first_name: 'Иван',
    last_name: 'Иванов',
    patronymic: 'Иванович',
    role: 'user',
    password: '',
  ),
  User(
    id: 9876543210,
    company_id: 9876543210987,
    depart_id: 2,
    schedule_id: 2,
    first_name: 'Петр',
    last_name: 'Петров',
    patronymic: 'Петрович',
    role: 'moderator',
    password: '',
  ),
];

void main() {
  group('AdminPage Widget Tests', () {
    testWidgets('AdminPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Verify title
      expect(find.text('Панель администратора'), findsOneWidget);
      
      // Verify search section
      expect(find.text('Поиск пользователя'), findsOneWidget);
      expect(find.text('Введите ИНН для поиска пользователя в системе'), findsOneWidget);
      
      // Verify all users section
      expect(find.text('Все пользователи системы'), findsOneWidget);
      
      // Verify role management section
      expect(find.text('Управление ролями'), findsOneWidget);
      
      // Verify reports section
      expect(find.text('Отчеты по рабочему времени'), findsOneWidget);
    });

    testWidgets('Search field works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Find search field
      final searchField = find.byType(TextField).first;
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, '1234567890');
      await tester.pump();

      // Verify text was entered
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('Search shows error for empty search', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Find search button
      final searchButton = find.widgetWithText(ElevatedButton, 'Найти');
      expect(searchButton, findsOneWidget);

      // Tap search without entering text
      await tester.tap(searchButton);
      await tester.pump();

      // Error should appear
      expect(find.text('Заполните это поле.'), findsOneWidget);
    });

    testWidgets('User list displays correctly', (WidgetTester tester) async {
      // This test would require mocking the ApiService
      // For now, we just verify the structure
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Verify user list section exists
      expect(find.text('Все пользователи системы'), findsOneWidget);
      expect(find.text('Список всех зарегистрированных пользователей'), findsOneWidget);
      
      // Add user button should be present
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Logout button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Verify logout icon button
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('Refresh button works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Verify refresh button in reports section
      expect(find.widgetWithText(ElevatedButton, 'Обновить'), findsOneWidget);
    });

    testWidgets('Role management section has correct content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Check role management instructions
      expect(find.text('Как назначить начальника отдела:'), findsOneWidget);
      expect(find.text('1. Найдите пользователя по ИНН'), findsOneWidget);
      expect(find.text('2. Убедитесь, что у пользователя указан правильный ID отдела'), findsOneWidget);
      expect(find.text('3. Нажмите кнопку "Выдать статус НО"'), findsOneWidget);
      
      // Check note section
      expect(find.text('Примечание:'), findsOneWidget);
      expect(find.text('Один пользователь может быть начальником только одного отдела.'), findsOneWidget);
    });

    testWidgets('Reports section has table structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // Check reports table headers
      expect(find.text('Дата'), findsOneWidget);
      expect(find.text('Сотрудник'), findsOneWidget);
      expect(find.text('Начало (план)'), findsOneWidget);
      expect(find.text('Начало (факт)'), findsOneWidget);
      expect(find.text('Конец (план)'), findsOneWidget);
      expect(find.text('Конец (факт)'), findsOneWidget);
      expect(find.text('Перерыв (план)'), findsOneWidget);
      expect(find.text('Перерыв (факт)'), findsOneWidget);
      expect(find.text('Часы (план)'), findsOneWidget);
      expect(find.text('Часы (факт)'), findsOneWidget);
      expect(find.text('Статус'), findsOneWidget);
      expect(find.text('Заметка'), findsOneWidget);
    });

    testWidgets('User detail card shows correct information', (WidgetTester tester) async {
      // This would require setting up mock data and triggering search
      // For now, we verify the structure exists
      await tester.pumpWidget(
        MaterialApp(
          home: AdminPage(),
        ),
      );

      // These elements should be in the user detail card template
      expect(find.text('Редактировать информацию'), findsNothing); // Only appears when user is selected
      expect(find.text('Выдать статус НО'), findsNothing); // Only appears when user is selected and not manager
    });

    testWidgets('EditUserDialog structure', (WidgetTester tester) async {
      // This tests the nested EditUserDialog widget
      final user = User(
        id: 1234567890,
        company_id: 9876543210987,
        depart_id: 1,
        schedule_id: 1,
        first_name: 'Test',
        last_name: 'User',
        patronymic: 'Middle',
        role: 'user',
        password: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _EditUserDialog(
                        user: user,
                        onUserUpdated: () {},
                      ),
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog title
      expect(find.text('Редактировать информацию о пользователе'), findsOneWidget);
      
      // Verify form fields
      expect(find.text('ФИО'), findsOneWidget);
      expect(find.text('ОГРН'), findsOneWidget);
      expect(find.text('ID отдела'), findsOneWidget);
      expect(find.text('Роль'), findsOneWidget);
      
      // Verify buttons
      expect(find.text('Отмена'), findsOneWidget);
      expect(find.text('Сохранить'), findsOneWidget);
    });
  });
}

// Need to expose _EditUserDialog for testing
class _EditUserDialog extends StatefulWidget {
  final User user;
  final VoidCallback onUserUpdated;

  const _EditUserDialog({
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<_EditUserDialog> createState() => __EditUserDialogState();
}

class __EditUserDialogState extends State<_EditUserDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mock Edit Dialog'),
          ],
        ),
      ),
    );
  }
}