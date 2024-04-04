// Work Order view

import 'package:flutter/material.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/work_order_list.dart';

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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  String _scanBarcodeResult = 'Scan a QR Code';

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
                        showFlashError(context, 'Invalid Data, Work Order not updated');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Update Work Order"),
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
}
