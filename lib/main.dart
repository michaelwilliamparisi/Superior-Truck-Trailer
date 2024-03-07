import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/user_model.dart';
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

    //insertion
    var userOne = const User(id:123,email:'userOne@gmail.com',password:'abc');
    DatabaseHandler.insertUser(userOne);
    //read
    print(DatabaseHandler.getUsers());
    //updation
    var userUpdate = User(
      id: userOne.id,
      email: userOne.email,
      password: userOne.password,
    );
    DatabaseHandler.updateUser(userUpdate);
    // Print the updated results.
    print(DatabaseHandler.getUsers());
    //deletion
    DatabaseHandler.deleteUser("userOne@gmail.com");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Use your LoginView widget here
    );
  }
}