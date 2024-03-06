import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'views/login_view.dart';
import 'models/user_model.dart';
import 'services/database_handler.dart';
//

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<Database> _database = DatabaseHandler.getDB();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Use your LoginView widget here
    );
  }
}