import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> uploadImageToStorage(
    File imageFile, String trailerId, String workOrderId) async {
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('images/$workOrderId.jpg');

    final UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask;

    // Return the reference to the uploaded image
    return storageRef.fullPath;
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    return null;
  }
}
