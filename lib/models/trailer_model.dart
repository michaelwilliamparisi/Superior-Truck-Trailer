import 'package:cloud_firestore/cloud_firestore.dart';

class Trailer {
  final String trailerId;
  final String companyName;
  final int milage;
  final String licensePlate;

  const Trailer({
    required this.trailerId,
    required this.companyName,
    required this.milage,
    required this.licensePlate,
  });

  Map<String, dynamic> mapUser() {
    return {
      'trailerId': trailerId,
      'companyName': companyName,
      'milage': milage,
      'licensePlate': licensePlate,
    };
  }

  factory Trailer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Trailer(
      trailerId: data['trailerId'] ?? '-1',
      companyName: data['companyName'] ?? '',
      milage: data['milage'] ?? '',
      licensePlate: data['licensePlate'] ?? '',
    );
  }
}
