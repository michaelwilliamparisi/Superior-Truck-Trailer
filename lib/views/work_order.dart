// Work Order view

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({Key? key}) : super(key: key);

  @override
  _WorkOrderViewState createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrder> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrCodeResult = "Scan a QR code";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order View"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // QR Scanner Option
          Expanded(
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
          ),
          // Display QR Code Result
          Text(
            qrCodeResult,
            style: const TextStyle(fontSize: 18.0),
          ),
          // Other Work Order Details
          // Add other components for work order details as needed
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
