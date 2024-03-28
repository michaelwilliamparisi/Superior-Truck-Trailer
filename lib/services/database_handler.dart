import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

//main function
class DatabaseHandler {
  static Future createUser(
      {required String email, required String password}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc();

    final json = {
      'email': email,
      'password': password,
    };

    await docUser.set(json);
  }

  static Future<bool> validUser(String email, String password) async {
    final users = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get(); // Query users by email

    if (users.docs.isNotEmpty) {
      // Check if a user with the provided email exists
      final userDoc =
          users.docs.first; // Assuming only one user with the email exists
      final userMap = userDoc.data() as Map<String, dynamic>; // Cast to Map

      // **Security Note:** It's highly recommended to **NOT** store passwords in plain text. Instead, use a secure hashing algorithm like bcrypt or scrypt before storing them in the database. During login, hash the user-provided password and compare it with the hashed password stored in the database.

      // **Here's an example (replace with actual hashing implementation):**
      // final String hashedPassword = hashPassword(password); // Implement secure hashing
      // return userMap['password'] == hashedPassword;

      // **Temporary placeholder (NOT SECURE):** This is for demonstration purposes only. Remove before production use.
      return userMap['password'] ==
          password; // This is not secure, replace with secure hashing
    } else {
      return false; // No user found with the provided email
    }
  }
}
