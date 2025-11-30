import 'package:flutter/material.dart';
import 'package:project_program/ui/loginPage.dart';
import 'package:project_program/ui/adminPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const LoginPage(),
      '/admin': (context) => const AdminPage(),
    },
  ));
}


