import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/employee_model.dart';
import 'views/login_view.dart';
import 'services/database_handler.dart';
//

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize database
    DatabaseHandler.getDB();

    DatabaseHandler.deleteUser("");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Use your LoginView widget here
    );
  }
}
