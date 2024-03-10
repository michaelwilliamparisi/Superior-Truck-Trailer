// Work Order view

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({super.key});

  @override
  _WorkOrderViewState createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrder> {
  final TextEditingController _jobCodesTEC = TextEditingController();
  final TextEditingController _partsTEC = TextEditingController();
  final TextEditingController _labourTEC = TextEditingController();

  //Trailer ID (Read Only)
  final String trailerID = "";
  //Company Name (Read Only)
  final String companyName = "";
  //Work Order ID (Read Only)
  final String workOrderID = "";
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
              padding: EdgeInsets.all(10),
              child: Text(trailerID),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(companyName),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(workOrderID),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _jobCodesTEC,
                obscureText: true,
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
                obscureText: true,
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
                obscureText: true,
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

                print("Create Work Order pressed");
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

  void scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }

    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
  }
}
