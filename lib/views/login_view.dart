import 'package:flutter/material.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/create_account.dart';
import 'package:frontend/views/work_order.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee_model.dart';

class LoginView extends StatefulWidget {
  final Database database;

  const LoginView({Key? key, required this.database}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  late TextEditingController _emailTEC;
  late TextEditingController _passwordTEC;

  @override
  void initState() {
    super.initState();
    _emailTEC = TextEditingController();
    _passwordTEC = TextEditingController();
  }

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/images/logo.JPG'),
            Container(
              height: 150,
              width: 190,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailTEC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter valid mail id as abc@gmail.com',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordTEC,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your secure password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String email = _emailTEC.text;
                final String password = _passwordTEC.text;

                if (email.isEmpty || password.isEmpty) {
                  showFlashError(context, "Email or Password error.");
                } else {
                  final Employee? validUser =
                      await DatabaseHandler.validUser(email, password);

                  if (validUser != null) {
                    _emailTEC.clear();
                    _passwordTEC.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkOrder()),
                    );
                  } else {
                    showFlashError(context, 'User is not in the system');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Sign In"),
            ),
            TextButton(
              onPressed: () {
                // Add functionality for "Forgot Password" here
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateView()),
                );
              },
              child: const Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
