// Work Order view

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/work_order_list.dart';

class CreateWorkOrder extends StatefulWidget {
  const CreateWorkOrder(
      {super.key,
      required this.trailer,
      required this.workOrders,
      required this.employeeCode});

  final Trailer trailer;
  final List<WorkOrders> workOrders;
  final String employeeCode;

  @override
  State<CreateWorkOrder> createState() =>
      _MyOrderState(trailer, workOrders, employeeCode);
}

class _MyOrderState extends State<CreateWorkOrder> {
  _MyOrderState(this.trailer, this.workOrders, this.employeeCode);

  final Trailer trailer;
  final List<WorkOrders> workOrders;
  final String employeeCode;
  final TextEditingController _jobCodesTEC = TextEditingController();
  final TextEditingController _partsTEC = TextEditingController();
  final TextEditingController _labourTEC = TextEditingController();
  String? imagePath;

  //Company Name (Read Only)
  final String companyName = "";
  //Work Order ID (Read Only)
  final String workOrderID = "";
  //Status
  final String status = "A";
  //job code(s)
  final String jobCodes = "";
  //Parts required
  final String parts = "";
  //labour
  final String labour = "";

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  String _scanBarcodeResult = 'Scan a QR Code';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order View"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Trailer ID: ${trailer.trailerId}"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Company Name: ${trailer.companyName}"),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Work Order ID: To Be Generated"),
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
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile = await imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null) {
                  try {
                    int workOrderLength = await DatabaseHandler.TotalWorkOrders(
                        trailer.trailerId);
                    String workOrderId =
                        '${trailer.trailerId}WO${workOrderLength.toString()}';

                    // Upload the image and get the reference
                    String? imagePathReference = await uploadImageToStorage(
                        File(pickedFile.path), trailer.trailerId, workOrderId);

                    if (imagePathReference != null) {
                      WorkOrders workOrder = WorkOrders(
                        workOrderNum: workOrderId,
                        empNum: employeeCode,
                        trailerNum: trailer.trailerId,
                        companyName: trailer.companyName,
                        status: status,
                        jobCodes: _jobCodesTEC.text,
                        parts: _partsTEC.text,
                        labour: double.parse(_labourTEC.text),
                        // Update the imagePath with the reference to the uploaded image
                        imagePath: imagePathReference,
                      );

                      // Add the work order to Firestore
                      await DatabaseHandler.AddWorkOrder(trailer, workOrder);

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
                      return;
                    }
                  } catch (e) {
                    print("Error uploading image to Firebase Storage: $e");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Failed to upload image to Firebase Storage"),
                    ),
                  );
                }
              },
              child: const Text("Create Work Order"),
            ),

            ElevatedButton(
              onPressed: () async {},
              child: const Text("Take Photo"),
            ),

            // Display the photo if available
            if (imagePath != null)
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
