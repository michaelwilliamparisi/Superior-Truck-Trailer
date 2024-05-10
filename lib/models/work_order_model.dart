import 'package:cloud_firestore/cloud_firestore.dart';

class WorkOrders {
  String _workOrderNum;
  String _empNum;
  String _trailerNum;
  String _companyName;
  String _status;
  String _jobCodes;
  String _parts;
  double _labour;
  String _imagePath;

  WorkOrders({
    required String workOrderNum,
    required String empNum,
    required String trailerNum,
    required String companyName,
    required String status,
    required String jobCodes,
    required String parts,
    required double labour,
    required String imagePath,
  })  : _workOrderNum = workOrderNum,
        _empNum = empNum,
        _trailerNum = trailerNum,
        _companyName = companyName,
        _status = status,
        _jobCodes = jobCodes,
        _parts = parts,
        _labour = labour,
        _imagePath = imagePath;

  String get workOrderNum => _workOrderNum;
  String get empNum => _empNum;
  String get trailerNum => _trailerNum;
  String get companyName => _companyName;
  String get status => _status;
  String get jobCodes => _jobCodes;
  String get parts => _parts;
  double get labour => _labour;
  String get imagePath => _imagePath;

  set workOrderNum(String value) {
    _workOrderNum = value;
  }

  set empNum(String value) {
    _empNum = value;
  }

  set trailerNum(String value) {
    _trailerNum = value;
  }

  set companyName(String value) {
    _companyName = value;
  }

  set status(String value) {
    _status = value;
  }

  set jobCodes(String value) {
    _jobCodes = value;
  }

  set parts(String value) {
    _parts = value;
  }

  set labour(double value) {
    _labour = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  Map<String, dynamic> mapUser() {
    return {
      'workOrderNum': _workOrderNum,
      'empNum': _empNum,
      'trailerNum': _trailerNum,
      'companyName': _companyName,
      'status': _status,
      'jobCodes': _jobCodes,
      'parts': _parts,
      'labour': _labour,
      'imagePath': _imagePath,
    };
  }

  factory WorkOrders.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return WorkOrders(
      workOrderNum: data['workOrderNum'] ?? '',
      empNum: data['empNum'] ?? '',
      trailerNum: data['trailerNum'] ?? '',
      companyName: data['companyName'] ?? '',
      status: data['status'] ?? 'P',
      jobCodes: data['jobCodes'] ?? '',
      parts: data['parts'] ?? '',
      labour: data['labour'] ?? 0,
      imagePath: data['imagePath'] ?? '',
    );
  }
}
