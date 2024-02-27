// login_view.dart

import 'package:flutter/material.dart';
import 'package:frontend/views/create_account.dart';
import 'package:frontend/views/work_order.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 190,
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Image.asset(
                  'asset/images/logo.JPG', // Adjust the path as needed
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter valid mail id as abc@gmail.com',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your secure password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add error handling and validation to the signin page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkOrder()),
                  );
                  // Add functionality for "Sign In" here
                  // This can include user authentication logic, navigation, etc.
                  print("Sign In pressed");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                  ),
                ),
                child: const Text("Sign In"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      // Add functionality for "Create Account" here
                      // This can include navigation to the create account page, etc.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateView()),
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
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
