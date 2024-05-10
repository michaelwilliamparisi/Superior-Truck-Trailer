import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImageToStorage(File imageFile) async {
  try {
    // Get a reference to the storage service, which is used to create references in your Firebase Storage bucket
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Create a reference to the location you want to upload to in Firebase Storage
    final Reference storageRef = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file to Firebase Storage
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    // Await the completion of the upload task
    await uploadTask;

    // Get the download URL of the uploaded file
    final String downloadURL = await storageRef.getDownloadURL();

    // Return the download URL
    return downloadURL;
  } catch (e) {
    // Handle any errors that occur during the upload process
    print('Error uploading image to Firebase Storage: $e');
    return null;
  }
}
