// Work Order view

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({Key? key}) : super(key: key);

  @override
  _WorkOrderViewState createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrder> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //late QRViewController controller;  
  String _scanBarcodeResult = 'Scan a QR Code';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order View"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            ElevatedButton(onPressed:scanQR, child: Text("Start QR Code scan")),
          // QR Scanner Option
          /*Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    qrCodeResult = scanData.code ?? "No QR code scanned";
                  });
                });
              },
            ),
          ),*/
          // Display QR Code Result
          Text(
            "$_scanBarcodeResult",
            style: const TextStyle(fontSize: 18.0),
          ),
          // Other Work Order Details
          // Add other components for work order details as needed
        ],
      ),
    );
  }

  void scanQR() async {

  String barcodeScanRes;

    try{

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "cancel",
        true,
        ScanMode.QR
      );

    }on PlatformException{
      barcodeScanRes = "Failed to get platform version";
    }

    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
  }
}
