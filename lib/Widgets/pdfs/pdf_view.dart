import 'dart:typed_data';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview PDF")),
      body: PdfPreview(
        maxPageWidth: 900,
        build: (format) => generatePdf(format),
      ),
    );
  }

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    // شعار الشركة من الإنترنت (mock)
    final pw.MemoryImage companyLogo = await networkImageToPdf(
      'https://res.cloudinary.com/dcfqtqz4z/image/upload/v1758839442/companies/iqka78f7p9sr1z5l92db.png',
    );

    // صور السيارة مؤقتة (mock)
    List<pw.MemoryImage> carImagesPdf = [];
    final placeholderUrls = [
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
    ];
    for (String url in placeholderUrls) {
      try {
        carImagesPdf.add(await networkImageToPdf(url));
      } catch (_) {}
    }

    // بيانات السيارة مؤقتة
    final mockCarData = {
      'model': 'Mercedes GLE 43, 2018',
      'plate': '123-XYZ',
      'vin': 'CHS123457793090FVFEVEV6',
      'mileage': '15000',
      'fuel': '50%',
      'color': 'White',
      'receivied on': "15/10/2025",
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Header
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(companyLogo, width: 80, height: 80),
              pw.SizedBox(width: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Company: DataHub AI',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Report: Inspection Report',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'Date: ${textToDate(DateTime.now(), withTime: true)}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Text(
            'Dear Customer,\nWe are pleased to inform you that we have received your car. Here are its details:',
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Car Details',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              _buildTableRow('Brand & Model & Year', mockCarData['model']!),
              _buildTableRow('Color', mockCarData['color']!),
              _buildTableRow('Plate Number', mockCarData['plate']!),
              _buildTableRow('VIN', mockCarData['vin']!),
              _buildTableRow('Mileage', mockCarData['mileage']!),
              _buildTableRow('Fuel', mockCarData['fuel']!),
              _buildTableRow('Receivied On', mockCarData['receivied on']!),
            ],
          ),
          pw.SizedBox(height: 20),

          // Car Images
          pw.Text(
            'Car Images',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          ...carImagesPdf.map(
            (img) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Image(
                img,
                width: 400,
                height: 250,
                fit: pw.BoxFit.cover,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Should you have any queries, please do not hesitate to reach out. Thank you for trusting us with your vehicle.\n\nWarm regards,\nDataHub AI',
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.TableRow _buildTableRow(String key, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            key,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(value)),
      ],
    );
  }
}

Future<pw.MemoryImage> networkImageToPdf(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return pw.MemoryImage(response.bodyBytes);
  } else {
    throw Exception("Failed to load image from $url");
  }
}
