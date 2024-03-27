import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/employee_model.dart';
import 'views/login_view.dart';
import 'services/database_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHandler.initDatabase();
  final validUser =
      await DatabaseHandler.validUser("user@email.com", "password");
  runApp(MainApp(database: database, validUser: validUser));
}

class MainApp extends StatelessWidget {
  final Database database;
  final Employee? validUser;

  const MainApp({Key? key, required this.database, required this.validUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(
          database: database), // Pass the database and validUser to LoginView
    );
  }
}
