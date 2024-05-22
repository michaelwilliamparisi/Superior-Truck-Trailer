// Work Order view

import 'package:flutter/services.dart';
import 'package:frontend/services/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/views/work_order_list.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';

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
  Uint8List? imageData;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  // String _scanBarcodeResult = 'Scan a QR Code';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    final workOrder = workOrders[widget.index];
    _jobCodesTEC.text = workOrders[index].jobCodes;
    _partsTEC.text = workOrders[index].parts;
    _labourTEC.text = workOrders[index].labour.toString();

    // Retrieve the image storage reference from Firestore
    final imagePath = workOrder.imagePath;
    if (imagePath != null) {
      // Update the state with the image storage reference
      final photoData = await retrievePhoto(imagePath);
      setState(() {
        imageData = photoData;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<Uint8List> loadLogoBytes() async {
    final ByteData data =
        await rootBundle.load('assets/images/logo.JPG'); // Load from assets
    return data.buffer.asUint8List();
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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

                  // Display photo here

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

                      // Update work order details
                      workOrders[index].jobCodes = jobCodes;
                      workOrders[index].parts = parts;
                      workOrders[index].labour = double.parse(labour);

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
                  // View the image from storage
                  Container(
                    height: 200,
                    child: imageData != null
                        ? Image.memory(imageData!)
                        : Text('No image available'),
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
                  ElevatedButton(
                    onPressed: () async {
                      final pdfData = await generateSingleWorkOrderPdf(
                          trailer, workOrders[index], imageData);
                      await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdfData);
                    },
                    child: const Text("Generate PDF"),
                  )
                ],
              ),
            ),
    );
  }
}
