import 'package:cloud_firestore/cloud_firestore.dart';

class Trailer {
  final String trailerId;
  final String companyName;
  final double length;
  final double width;
  final double height;
  final double weight;


  const Trailer({
    required this.trailerId,
    required this.companyName,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> mapUser() {
    return {
      'trailerId': trailerId,
      'companyName': companyName,
      'length': length,
      'width': width,
      'height': height,
      'weight': weight,
    };
  }

  factory Trailer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Trailer(
      trailerId: data['trailerId'] ?? '-1',
      companyName: data['companyName'] ?? '',
      length: data['length'] ?? 0.0,
      width: data['width'] ?? 0.0,
      height: data['height'] ?? 0.0,
      weight: data['weight'] ?? 0.0,
    );
  }

}
