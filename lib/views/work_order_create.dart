// Work Order view

import 'dart:io';

import 'package:flutter/material.dart';
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

  // holds the photos
  String? beforePhotoPath;
  String? afterPhotoPath;

  //Company Name (Read Only)
  final String companyName = "";
  //Work Order ID (Read Only)
  final String workOrderID = "";
  //Status
  final String status = "P";
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
                try {
                  final String jobCodes = _jobCodesTEC.text;
                  final String parts = _partsTEC.text;
                  final String labour = _labourTEC.text;

                  int workOrderLength =
                      await DatabaseHandler.TotalWorkOrders(trailer.trailerId);

                  // placeholder values
                  String beforePhotoPath = "path/to/before/photo.jpg";
                  String afterPhotoPath = "path/to/before/photo.jpg";

                  WorkOrders workOrder = WorkOrders(
                    workOrderNum:
                        '${trailer.trailerId}WO${workOrderLength.toString()}',
                    empNum: employeeCode,
                    trailerNum: trailer.trailerId,
                    companyName: trailer.companyName,
                    status: status,
                    jobCodes: jobCodes,
                    parts: parts,
                    labour: double.parse(labour),
                    beforePhotoPath: beforePhotoPath, // this will change
                    afterPhotoPath: afterPhotoPath, // this will change
                  );

                  await DatabaseHandler.AddWorkOrder(trailer, workOrder);

                  workOrders.add(workOrder);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderList(
                          workOrders: workOrders,
                          trailer: trailer,
                          employeeCode: employeeCode,
                        ),
                      ));
                } catch (e) {
                  // Handle the error here
                  print("Error creating work order: $e");
                  // Show a snackbar or dialog to inform the user about the error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error creating work order: $e"),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Create Work Order"),
            ),
            // Button to take the BEFORE photo
            ElevatedButton(
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile =
                    await imagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  beforePhotoPath = pickedFile?.path;
                });
              },
              child: const Text("Capture Before Photo"),
            ),
            // Display before photo if available
            if (beforePhotoPath != null)
              Container(
                height: 200,
                child: Image.file(
                  File(beforePhotoPath!),
                  fit: BoxFit.cover,
                ),
              ),
            // Button to take the AFTER photo
            ElevatedButton(
              onPressed: () async {
                final imagePicker = ImagePicker();
                final pickedFile =
                    await imagePicker.pickImage(source: ImageSource.camera);
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
          ],
        ),
      ),
    );
  }
}
