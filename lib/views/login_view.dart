import 'package:flutter/material.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/create_account.dart';
import 'package:frontend/views/work_order.dart';

import '../models/user_model.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();

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

                if (await DatabaseHandler.validUser(email, password)){
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkOrder()),
                  );
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
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}