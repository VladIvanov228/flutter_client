import 'package:flutter_test/flutter_test.dart';
import 'package:project_program/entity/pagination.dart';

void main() {
  group('Pagination', () {
    test('fromJson should create Pagination from JSON', () {
      final json = {
        'per_page': '20',
        'total': '150',
        'page': '3',
        'pages': '8'
      };

      final pagination = Pagination.fromJson(json);

      expect(pagination.per_page, 20);
      expect(pagination.total, 150);
      expect(pagination.page, 3);
      expect(pagination.pages, 8);
    });

    test('fromJson should handle numeric values', () {
      final json = {
        'per_page': 10,
        'total': 100,
        'page': 5,
        'pages': 10
      };

      final pagination = Pagination.fromJson(json);

      expect(pagination.per_page, 10);
      expect(pagination.total, 100);
      expect(pagination.page, 5);
      expect(pagination.pages, 10);
    });

    test('Constructor should initialize all fields', () {
      final pagination = Pagination(
        per_page: 25,
        total: 250,
        page: 2,
        pages: 10,
      );

      expect(pagination.per_page, 25);
      expect(pagination.total, 250);
      expect(pagination.page, 2);
      expect(pagination.pages, 10);
    });

    test('Pagination with single page', () {
      final pagination = Pagination(
        per_page: 50,
        total: 45,
        page: 1,
        pages: 1,
      );

      expect(pagination.per_page, 50);
      expect(pagination.total, 45);
      expect(pagination.page, 1);
      expect(pagination.pages, 1);
    });

    test('Pagination with large dataset', () {
      final pagination = Pagination(
        per_page: 100,
        total: 10000,
        page: 50,
        pages: 100,
      );

      expect(pagination.per_page, 100);
      expect(pagination.total, 10000);
      expect(pagination.page, 50);
      expect(pagination.pages, 100);
    });

    test('fromJson should handle string numbers with spaces', () {
      final json = {
        'per_page': ' 25 ',
        'total': ' 300 ',
        'page': ' 4 ',
        'pages': ' 12 '
      };

      final pagination = Pagination.fromJson(json);

      expect(pagination.per_page, 25);
      expect(pagination.total, 300);
      expect(pagination.page, 4);
      expect(pagination.pages, 12);
    });
  });
}