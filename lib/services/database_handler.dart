import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/employee_model.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';

//main function
class DatabaseHandler {
  static Future createUser({required Employee employee}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc();

    final json = {
      'email': employee.email,
      'password': employee.password,
      'employeeCode': employee.employeeCode,
      'employeeStatus': employee.employeeStatus
    };

    await docUser.set(json);
  }

  static Future<bool> AddWorkOrder(
      Trailer trailer, WorkOrders workOrders) async {
    final docWorkOrder = FirebaseFirestore.instance
        .collection("trailers")
        .doc(trailer.trailerId)
        .collection("WorkOrders")
        .doc(workOrders.workOrderNum);

    final json = {
      'workOrderNum': workOrders.workOrderNum,
      'empNum': workOrders.empNum,
      'trailerNum': workOrders.trailerNum,
      'companyName': workOrders.companyName,
      'status': workOrders.status,
      'jobCodes': workOrders.jobCodes,
      'parts': workOrders.parts,
      'labour': workOrders.labour,
    };

    await docWorkOrder.set(json);

    return true;
  }

  static Future<bool> AddTrailer(Trailer trailer) async {
    final docWorkOrder = FirebaseFirestore.instance
        .collection("trailers")
        .doc(trailer.trailerId);

    final json = {
      'trailerId': trailer.trailerId,
      'companyName': trailer.companyName,
      'length': trailer.length,
      'width': trailer.width,
      'height': trailer.height,
      'weight': trailer.weight,
    };

    await docWorkOrder.set(json);

    return true;
  }

  static bool UpdateWorkOrder(Trailer trailer, WorkOrders workOrder) {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('trailers')
          .doc(workOrder.trailerNum)
          .collection('WorkOrders')
          .doc(workOrder.workOrderNum);

      documentReference.update({
        'jobCodes': workOrder.jobCodes,
        'parts': workOrder.parts,
        'labour': workOrder.labour
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Employee> validUser(String email, String password) async {
    final users = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get(); // Query users by email

    if (users.docs.isNotEmpty) {
      // Check if a user with the provided email exists
      DocumentSnapshot documentSnapshot =
          users.docs.first; // Assuming only one user with the email exists
      print('Enter ');
      return Employee.fromFirestore(documentSnapshot);
    } else {
      return Employee(
          employeeCode: '-1',
          email: '-1',
          password: 'P',
          employeeStatus: 'N/A'); // No user found with the provided email
    }
  }

  static Future<Trailer> FindTrailer(String trailerId) async {
    try {
      final trailerDoc;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("trailers")
          .doc(trailerId)
          .get();

      return Trailer.fromFirestore(documentSnapshot);
    } catch (e) {
      return Trailer(
          trailerId: '-1',
          companyName: '',
          length: 0.0,
          width: 0.0,
          height: 0.0,
          weight: 0.0);
    }
  }

  static Future<List<WorkOrders>> FindTrailerOrders(String trailerId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trailers')
        .doc(trailerId)
        .collection('WorkOrders')
        .where('status', isNotEqualTo: 'A')
        .get();
    return snapshot.docs.map((doc) => WorkOrders.fromFirestore(doc)).toList();
  }

  static Future<void> deleteWorkOrder(
    String trailerId,
    String workOrderId,
  ) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('trailers')
        .doc(trailerId)
        .collection('WorkOrders')
        .doc(workOrderId);

    documentReference.update({
      'status': 'D',
    });
  }

  static Future<int> TotalWorkOrders(String trailerId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trailers')
        .doc(trailerId)
        .collection('WorkOrders')
        .get();
    List<WorkOrders> workOrders =
        snapshot.docs.map((doc) => WorkOrders.fromFirestore(doc)).toList();

    return workOrders.length;
  }
}
