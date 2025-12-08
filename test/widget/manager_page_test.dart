import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_program/ui/managerPage.dart'; 

void main() {
  testWidgets('ManagerPage отображает структуру без данных', (tester) async {
    // Запускаем виджет
    await tester.pumpWidget(
      MaterialApp(
        home: ManagerPage(userId: 999999), // несуществующий ID
      ),
    );

    // Должен показаться индикатор загрузки
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Ждём завершения загрузки (даже с ошибкой)
    await tester.pumpAndSettle(); // ждём асинхронных операций

    // Проверяем, что заголовок отображается
    expect(find.text('Панель начальника отдела'), findsOneWidget);
    expect(find.text('Выйти'), findsOneWidget);

    // Проверяем вкладки
    expect(find.text('Моя работа'), findsOneWidget);
    expect(find.text('Сотрудники'), findsOneWidget);
    expect(find.text('Отчеты'), findsOneWidget);

    // Переключаемся на вкладку "Сотрудники"
    await tester.tap(find.text('Сотрудники'));
    await tester.pumpAndSettle();

    // Должно быть сообщение "Сотрудники не найдены"
    expect(find.text('Сотрудники не найдены'), findsOneWidget);

    // Переключаемся на "Отчеты"
    await tester.tap(find.text('Отчеты'));
    await tester.pumpAndSettle();

    // Должно быть "Данные отсутствуют"
    expect(find.text('Данные отсутствуют'), findsOneWidget);
  });
}