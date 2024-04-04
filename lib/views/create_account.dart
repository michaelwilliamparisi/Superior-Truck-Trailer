// Create account view

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/employee_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/login_view.dart';
import 'package:path/path.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController employeeCodeController = TextEditingController();
    TextEditingController emailCodeController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Adjust the height as needed
              // Title and Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10), // Adjust the width as needed
                  Image.asset(
                    'asset/images/logo.JPG', // Adjust the path as needed
                    height: 40, // Adjust the height as needed
                  ),
                ],
              ),
              const SizedBox(height: 20), // Adjust the height as needed
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: employeeCodeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Employee Code',
                    hintText: 'Enter your employee code',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: emailCodeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter email',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String employeeCode = employeeCodeController.text;
                  String email = emailCodeController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (employeeCode.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty) {
                    showFlashError(
                        context, "Employee code, email, password error.");
                    employeeCodeController.text = "";
                    emailCodeController.text = "";
                    passwordController.text = "";
                    confirmPasswordController.text = "";
                  }
                  // Validate email format
                  final emailPattern =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailPattern.hasMatch(email)) {
                    // If email format is invalid, show an error message

                    showFlashError(context, "Not a valid email.");
                    emailCodeController.text = "";

                    return; // Exit the function early
                  }
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    showFlashError(context,
                        "The password and Confirm Password do not match.");
                    passwordController.text = "";
                    confirmPasswordController.text = "";
                  }
                  // This can include validation, storing user data, etc.
                  if (password == confirmPassword) {
                    // Create Employee Object
                    Employee employee = Employee(
                      employeeCode: employeeCode,
                      email: email,
                      password: password,
                      employeeStatus: 'E',
                    );

                    // Insert user into the database
                    bool userCreated = await DatabaseHandler.createUser(employee: employee);

                    if (userCreated) {

                      Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );

                    } else {

                      showFlashError(context,
                        "Invalid Employee Code");
                      employeeCodeController.text = "";

                    }

                  } else {
                    confirmPassword == "";
                    password == "";
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                  ),
                ),
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
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
