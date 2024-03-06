import 'package:flutter/material.dart';
import 'views/login_view.dart';
//

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Use your LoginView widget here
    );
  }
}