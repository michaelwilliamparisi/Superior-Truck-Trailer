import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/employee_model.dart';

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

  static validUser(String email, String password) {}
}
