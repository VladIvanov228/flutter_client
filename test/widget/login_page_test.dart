import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_program/ui/loginPage.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verify that the title appears
      expect(find.text('Вход в систему'), findsOneWidget);
      expect(find.text('Введите ваш ИНН и пароль для входа'), findsOneWidget);

      // Verify input fields are present
      expect(find.widgetWithText(TextField, 'ИНН (логин)'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Пароль'), findsOneWidget);

      // Verify login button is present
      expect(find.widgetWithText(ElevatedButton, 'Войти'), findsOneWidget);
    });

    testWidgets('INN field shows error when empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Tap the login button without entering INN
      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
      await tester.pump();

      // Error should be shown
      expect(find.text('Заполните это поле.'), findsOneWidget);
    });

    testWidgets('INN field shows error for non-digits', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Enter non-digit characters in INN field
      await tester.enterText(
        find.widgetWithText(TextField, 'ИНН (логин)'),
        'abc123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
      await tester.pump();

      // Error about digits only should appear
      expect(find.text('ИНН должен содержать только цифры.'), findsOneWidget);
    });

    testWidgets('Password field shows error when empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Enter valid INN but no password
      await tester.enterText(
        find.widgetWithText(TextField, 'ИНН (логин)'),
        '1234567890',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
      await tester.pump();

      // Password error should appear
      expect(find.text('Заполните это поле.'), findsOneWidget);
    });

    testWidgets('Error messages clear when typing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Trigger error by tapping login without input
      await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
      await tester.pump();

      // Error should be visible
      expect(find.text('Заполните это поле.'), findsAtLeast(1));

      // Start typing in INN field
      await tester.enterText(
        find.widgetWithText(TextField, 'ИНН (логин)'),
        '1',
      );
      await tester.pump();

      // INN error should clear
      expect(find.text('Заполните это поле.'), findsNothing);
    });

    testWidgets('Password field is obscured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find password field
      final passwordField = find.widgetWithText(TextField, 'Пароль');
      expect(passwordField, findsOneWidget);

      // Get the text field
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('INN field only accepts digits', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find INN field
      final innField = find.widgetWithText(TextField, 'ИНН (логин)');
      
      // Try to enter non-digits
      await tester.enterText(innField, 'abc123def');
      await tester.pump();
      
      // Get the current text
      final textField = tester.widget<TextField>(innField);
      final controller = textField.controller;
      
      // The field should only accept digits due to FilteringTextInputFormatter.digitsOnly
      // In practice, non-digits won't be entered at all
      expect(controller!.text, '123'); // Only digits remain
    });

    testWidgets('UI has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Check for container with shadow
      expect(find.byType(Card), findsOneWidget);
      
      // Check for centered layout
      expect(find.byType(Center), findsOneWidget);
      
      // Check for scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Login button has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Find login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Войти');
      expect(loginButton, findsOneWidget);

      // Get the button widget
      final button = tester.widget<ElevatedButton>(loginButton);
      
      // Check button style
      expect(button.style!.backgroundColor!.resolve({}), const Color(0xFF1E3A8A));
    });
  });

  tearDown(() {
    Get.reset();
  });
}