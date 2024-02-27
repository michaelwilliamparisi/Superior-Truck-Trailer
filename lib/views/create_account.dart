// Create account view

import 'package:flutter/material.dart';

class CreateView extends StatelessWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Employee Code',
                    hintText: 'Enter your employee code',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter your username',
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
                    hintText: 'Enter your password',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for creating an account
                  // This can include validation, storing user data, etc.
                  print("Create Account pressed");
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
}
