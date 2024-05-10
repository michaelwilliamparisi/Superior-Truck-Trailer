// Work Order view

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/work_order_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EditWorkOrder extends StatefulWidget {
  const EditWorkOrder(
      {super.key,
      required this.trailer,
      required this.workOrders,
      required this.index,
      required this.employeeCode});

  final Trailer trailer;
  final List<WorkOrders> workOrders;
  final int index;
  final String employeeCode;

  @override
  State<EditWorkOrder> createState() =>
      _MyOrderState(trailer, workOrders, index, employeeCode);
}

class _MyOrderState extends State<EditWorkOrder> {
  _MyOrderState(this.trailer, this.workOrders, this.index, this.employeeCode);

  final Trailer trailer;
  final List<WorkOrders> workOrders;
  final int index;
  final String employeeCode;
  bool isLoading = false;
  TextEditingController _jobCodesTEC = TextEditingController();
  TextEditingController _partsTEC = TextEditingController();
  TextEditingController _labourTEC = TextEditingController();
  String? imagePath; // path of the selected image

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  String _scanBarcodeResult = 'Scan a QR Code';

  String? afterPhotoPath;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    setState(() {
      isLoading = true;
    });
    _jobCodesTEC.text = workOrders[index].jobCodes;
    _partsTEC.text = workOrders[index].parts;
    _labourTEC.text = workOrders[index].labour.toString();
    setState(() {
      isLoading = false;
    });
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(
        () {
          imagePath = result.files.single.path;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order View"),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Trailer Identification Number: ${trailer.trailerId}"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Company Name: ${trailer.companyName}"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Work Order ID: ${workOrders[index].workOrderNum}"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Created by Employee: $employeeCode"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _jobCodesTEC,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Job Codes - Seperated By Comma',
                        hintText: 'Seperate By Comma Ex. 13,4,16,10',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _partsTEC,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Required Parts',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _labourTEC,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Labour Cost',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    //Button to upload image
                    onPressed: _pickImage,
                    child: const Text("Select Image"),
                  ),
                  // Display selected image if available
                  if (imagePath != null)
                    Container(
                      height: 200,
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      final String jobCodes = _jobCodesTEC.text;
                      final String parts = _partsTEC.text;
                      final String labour = _labourTEC.text;

                      // Check if any of the text fields are empty
                      if (jobCodes.isEmpty || parts.isEmpty || labour.isEmpty) {
                        // Show error message
                        showFlashError(context, 'Please fill in all fields.');

                        return; // Exit the function
                      }
                      // Upload image to storage and get image URL
                      final imageUrl = await uploadImageToStorage();

                      workOrders[index].jobCodes = jobCodes;
                      workOrders[index].parts = parts;
                      workOrders[index].labour = double.parse(labour);
                      workOrders[index].imagePath = imageUrl!;

                      bool updated = DatabaseHandler.UpdateWorkOrder(
                          trailer, workOrders[index]);

                      if (updated) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkOrderList(
                              workOrders: workOrders,
                              trailer: trailer,
                              employeeCode: employeeCode,
                            ),
                          ),
                        );
                      } else {
                        //Error Handling
                        showFlashError(
                            context, 'Invalid Data, Work Order not updated');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Update Work Order"),
                  ),
                  // Button to take the AFTER photo
                  ElevatedButton(
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      setState(() {
                        afterPhotoPath = pickedFile?.path;
                      });
                    },
                    child: const Text("Capture After Photo"),
                  ),
                  // Display after photo if available
                  if (afterPhotoPath != null)
                    Container(
                      height: 200,
                      child: Image.file(
                        File(afterPhotoPath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkOrderList(
                            workOrders: workOrders,
                            trailer: trailer,
                            employeeCode: employeeCode,
                          ),
                        ),
                      );
                    },
                    child: const Text("Exit Work Order"),
                  ),
                ],
              ),
            ),
    );
  }

  Future<String?> uploadImageToStorage() async {
    // Upload image to your storage (e.g., Firebase Storage) and get the download URL
    // This is just a placeholder function, you need to implement the actual upload logic
    // For example, if you're using Firebase Storage, you can use Firebase Storage SDK for Flutter
    // Return the download URL of the uploaded image
    return 'https://example.com/image.jpg'; // Placeholder URL
  }
}
