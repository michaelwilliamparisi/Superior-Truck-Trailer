import 'dart:io';
import 'dart:typed_data';

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

// Get the data from the database

// Get the image data in storage for each image reference

// Display the images
Future<Uint8List?> retrievePhoto(String? imagePath) async {
  if (imagePath != null) {
    try {
      final ref = FirebaseStorage.instance.ref(imagePath);
      final downloadData = await ref.getData();
      return downloadData;
    } catch (e) {
      print('Error retrieving photo: $e');
      return null;
    }
  }
  return null;
}
