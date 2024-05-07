// Work Order view

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/models/employee_model.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/trailer_create.dart';
import 'package:frontend/views/work_order_list.dart';

class WorkOrderSearch extends StatefulWidget {
  const WorkOrderSearch({super.key, required this.employeeCode});

  final String employeeCode;

  @override
  _WorkOrderViewState createState() => _WorkOrderViewState(employeeCode);
}

class _WorkOrderViewState extends State<WorkOrderSearch> {
  _WorkOrderViewState(this.employeeCode);

  final String employeeCode;

  final TextEditingController _trailerIdTEC = TextEditingController();

  //Trailer ID
  final String trailerID = "";

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;
  String _scanBarcodeResult = 'Scan a QR Code';

  // Error handling function
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
        title: const Text("Work Order Search"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/images/logo.JPG'),
            Container(
              height: 150,
              width: 190,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            ElevatedButton(
                onPressed: scanQR, child: Text("Start QR Code scan")),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _trailerIdTEC,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Trailer ID',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String trailerId = _trailerIdTEC.text;
                TrailerSearch(trailerId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("View Work Orders"),
            ),
          ],
        ),
      ),
    );
  }

  void scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = "-2";
    }

    TrailerSearch(barcodeScanRes);
  }

  void TrailerSearch(String trailerId) async {
    if (trailerId == '-1') {
      //Call Error Function
    } else if (trailerId == '-2') {
      //Call Error Function
    } else {
      //Query Database
      Trailer trailer = await DatabaseHandler.FindTrailer(trailerId);

      print(trailer.trailerId);

      if (trailer.trailerId == '-1') {
        //Call Error Function
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Trailer Id Not Found"),
                  content:
                      const Text("Would you like to create this trailer Id?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateTrailer(
                                    trailerId: trailerId,
                                    employeeCode: employeeCode)));
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'No');
                        showFlashError(context, 'Invalid Trailer ID');
                      },
                      child: const Text("No"),
                    ),
                  ],
                ));
      } else {
        List<WorkOrders> workOrders =
            await DatabaseHandler.FindTrailerOrders(trailerId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkOrderList(
                workOrders: workOrders,
                trailer: trailer,
                employeeCode: employeeCode),
          ),
        );
      }
    }
  }
}
