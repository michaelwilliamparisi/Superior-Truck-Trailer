// Work Order view

import 'package:flutter/material.dart';
import 'package:frontend/models/employee_model.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/work_order_list.dart';
import 'package:frontend/views/work_order_search.dart';

class CreateTrailer extends StatefulWidget {
  const CreateTrailer(
      {super.key, required this.trailerId, required this.employeeCode});

  final String trailerId;
  final String employeeCode;

  @override
  State<CreateTrailer> createState() => _MyOrderState(trailerId, employeeCode);
}

class _MyOrderState extends State<CreateTrailer> {
  _MyOrderState(this.trailerId, this.employeeCode);

  final String trailerId;
  final String employeeCode;
  final TextEditingController _companyNameTEC = TextEditingController();
  final TextEditingController _lengthTEC = TextEditingController();
  final TextEditingController _widthTEC = TextEditingController();
  final TextEditingController _heightTEC = TextEditingController();
  final TextEditingController _weightTEC = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  String _scanBarcodeResult = 'Scan a QR Code';

  @override
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Trailer ID: $trailerId"),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _companyNameTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _lengthTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Length - Enter in meters without symbol',
                  hintText: 'Example: 6.8',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _widthTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Width - Enter in meters without symbol',
                  hintText: "Example: 2.4",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _heightTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Height - Enter in meters without symbol',
                  hintText: "Example: 3.6",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _weightTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Weight - Enter in pounds without symbol',
                  hintText: 'Example: 150.2',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String companyName = _companyNameTEC.text;

                try {
                  final double length = double.parse(_lengthTEC.text);
                  final double width = double.parse(_widthTEC.text);
                  final double height = double.parse(_heightTEC.text);
                  final double weight = double.parse(_weightTEC.text);

                  Trailer trailer = Trailer(
                      trailerId: trailerId,
                      companyName: companyName,
                      length: length,
                      width: width,
                      height: height,
                      weight: weight);

                  DatabaseHandler.AddTrailer(trailer);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderSearch(
                          employeeCode: employeeCode,
                        ),
                      ));
                } catch (e) {
                  //Error Handling
                  showFlashError(context, "Measurements Must Be Numeric");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Create Work Order"),
            ),
          ],
        ),
      ),
    );
  }
}
