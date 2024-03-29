import 'package:flutter/material.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/create_account.dart';
import 'package:frontend/views/work_order_search.dart';

import '../models/employee_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // final TextEditingController _emailTEC = TextEditingController();
  // final TextEditingController _passwordTEC = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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

  // Error handling function
  @override
  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build logic here
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

                // checking if text fields are empty
                if (email.isEmpty || password.isEmpty) {
                  showFlashError(context, "Email or Password error.");
                  return;
                }

                final Employee loginEmployee = await DatabaseHandler.validUser(email, password);

                if (loginEmployee.employeeCode != '-1') {
                  _emailTEC.text = "";
                  _passwordTEC.text = "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkOrderSearch(employeeCode: loginEmployee.employeeCode,)),
                  );
                } else {
                  showFlashError(context, 'Invalid Email or Password.');
                  _emailTEC.text = "";
                  _passwordTEC.text = "";
                }

                // Add functionality for "Sign In" here

                // This can include user authentication logic, navigation, etc.
                print("Sign In pressed");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Sign In"),
            ),
            TextButton(
              onPressed: () {
                // Add functionality for "Forgot Password" here
                // This can include showing a dialog, navigating to a recovery page, etc.
                print("Forgot Password pressed");
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
                // Add functionality for "Forgot Password" here
                // This can include showing a dialog, navigating to a recovery page, etc.
                print("Create account");
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
}
