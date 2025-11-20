import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(Map data) async {
  final pdf = pw.Document();
  

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          children: [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              color: PdfColors.green,
              child: pw.Text(
                "Inspection Report",
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 22),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Plate Number"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["plate"]),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text("Chassis"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["chassis"]),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            pw.Text(
              "Notes:",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(data["notes"]),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
