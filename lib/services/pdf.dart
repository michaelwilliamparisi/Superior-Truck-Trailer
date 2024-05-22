import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:frontend/models/work_order_model.dart';

Future<Uint8List> generateSingleWorkOrderPdf(
    Trailer trailer, WorkOrders workOrder, Uint8List? image) async {
  final pdf = pw.Document();

  final titleStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final headingStyle =
      pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);
  final regularStyle = pw.TextStyle(fontSize: 12);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Work Order Report', style: titleStyle),
            pw.SizedBox(height: 20),
            pw.Text('Trailer Information', style: headingStyle),
            pw.SizedBox(height: 10),
            _buildInfoRow('Trailer ID:', trailer.trailerId, regularStyle),
            _buildInfoRow('Company Name:', trailer.companyName, regularStyle),
            pw.SizedBox(height: 20),
            pw.Text('Work Order Information', style: headingStyle),
            pw.SizedBox(height: 10),
            _buildInfoRow(
                'Work Order ID:', workOrder.workOrderNum, regularStyle),
            _buildInfoRow('Job Codes:', workOrder.jobCodes, regularStyle),
            _buildInfoRow('Parts:', workOrder.parts, regularStyle),
            _buildInfoRow(
                'Labour Cost:', workOrder.labour.toString(), regularStyle),
            if (image != null) ...[
              pw.SizedBox(height: 20),
              pw.Text('Attached Photo', style: headingStyle),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(image), height: 200, width: 200),
            ],
            pw.SizedBox(height: 20),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildInfoRow(String label, String value, pw.TextStyle style) {
  return pw.Row(
    children: [
      pw.Text(label, style: style.copyWith(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(width: 10),
      pw.Text(value, style: style),
    ],
  );
}
