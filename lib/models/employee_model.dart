import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String employeeCode;
  final String email;
  final String password;
  final String employeeStatus;
  // final String Fname;
  // final String Lname;

  const Employee({
    required this.employeeCode,
    required this.email,
    required this.password,
    required this.employeeStatus,
    // required this.Fname,
    // required this.Lname,
  });

  Map<String, dynamic> mapUser() {
    return {
      'employeeCode': employeeCode,
      'email': email,
      'password': password,
      'employeeStatus': employeeStatus,
      // 'Fname': Fname,
    };
  }

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Employee(
      employeeCode: data['employeeCode'] ?? '-1',
      email: data['email'] ?? '-1',
      password: data['password'] ?? 'P',
      employeeStatus: data['employeeStatus'] ?? 'E'
    );
  }

}
