import 'package:flutter/material.dart';
import 'package:frontend/views/work_order.dart';
import 'database_helper.dart';

class LoginView extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  LoginView({Key? key}) : super(key: key);

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
              // ... (your existing UI code)

              ElevatedButton(
                onPressed: () async {
                  // Fetch the values entered by the user
                  String userName =
                      "user_name"; // Replace with the actual text field value
                  String password =
                      "password"; // Replace with the actual text field value

                  // Check if the user exists in the database
                  bool isUserValid = true;
                      //await dbHelper.isUserValid(userName, password);

                  if (isUserValid) {
                    // User is valid, navigate to the WorkOrder page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkOrder()),
                    );
                  } /*else {
                    // User is not valid, show an error message or handle accordingly
                    print("Invalid credentials");
                  }*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Sign In"),
              ),

              // ... (your existing UI code)
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
