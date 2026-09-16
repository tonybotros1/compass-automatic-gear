import 'dart:convert';
import 'dart:io';

import 'package:datahubai/Models/car trading/car_trade_model.dart';
import 'package:datahubai/Models/car trading/car_trading_purchase_agreement_model.dart';
import 'package:datahubai/Widgets/pdfs/car_purchase_invoice_pdf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  group('purchase amount words', () {
    test('handles zero, fractions, and decimal rounding across a whole unit', () {
      expect(carPurchaseAmountInWords(0), 'Zero Dirhams only');
      expect(
        carPurchaseAmountInWords(125000.25),
        'One hundred and twenty-five thousand Dirhams and twenty-five Fils only',
      );
      expect(carPurchaseAmountInWords(0.05), 'Zero Dirhams and five Fils only');
      expect(carPurchaseAmountInWords(1.005), 'One Dirhams and one Fils only');
      expect(carPurchaseAmountInWords(999.995), 'One thousand Dirhams only');
      expect(carPurchaseAmountInWords(0.0000001), 'Zero Dirhams only');
      expect(
        carPurchaseAmountInWords(1000001),
        'One million and one Dirhams only',
      );
    });

    test('uses company currency names and rejects invalid amounts', () {
      expect(
        carPurchaseAmountInWords(
          35.62,
          currencyName: 'Dollars',
          subunitName: 'Cents',
        ),
        'Thirty-five Dollars and sixty-two Cents only',
      );
      expect(() => carPurchaseAmountInWords(-1), throwsArgumentError);
      expect(() => carPurchaseAmountInWords(double.nan), throwsArgumentError);
      expect(
        () => carPurchaseAmountInWords(double.infinity),
        throwsArgumentError,
      );
    });
  });

  final vehicle = CarTradeModel(
    carBrand: 'Example Motors',
    carModel: 'Touring',
    trim: 'Premium',
    year: '2024',
    colorOut: 'Silver',
    vin: 'SAMPLEVIN000000001',
    engineNumber: 'SAMPLE-ENGINE-001',
    mileage: 28450,
  );
  const company = <String, dynamic>{
    'company_name': 'Example Vehicle Trading LLC',
    'address': 'Example Business Centre, Dubai, United Arab Emirates',
    'phone': '+971 00 000 0000',
    'currency_code': 'AED',
    'currency_name': 'Dirhams',
    'subunit_name': 'Fils',
  };

  CarTradingPurchaseAgreementModel agreement({
    double amount = 87500.25,
    double paid = 20000,
    bool long = false,
  }) => CarTradingPurchaseAgreementModel(
    agreementType: 'buy',
    agreementNumber: long ? 'SAMPLE-PURCHASE-LONG' : 'SAMPLE-PURCHASE-001',
    agreementDate: DateTime(2026, 9, 15),
    sellerName: long
        ? 'Example International Vehicle Ownership and Automotive Distribution Services Company Limited, represented by Example Seller'
        : 'Example Seller',
    sellerID: 'SAMPLE-ID-001',
    sellerPhone: '+971 00 000 0001',
    buyerName: 'Example Vehicle Trading LLC',
    buyerID: 'SAMPLE-LICENCE-001',
    buyerPhone: '+971 00 000 0000',
    amount: amount,
    aownpayment: paid,
    paymentMethod: 'bank_transfer',
    note: long
        ? List.generate(
            40,
            (i) =>
                'Inspection note ${i + 1}: The synthetic example records the vehicle condition and documents supplied, with all agreed details available for both parties to review.',
          ).join('\n')
        : 'Two keys and service records supplied with the vehicle.',
  );

  test(
    'generates a printable invoice for partial, unpaid and full payments',
    () async {
      for (final paid in [20000.0, 0.0, 87500.25]) {
        final bytes = await generateCarPurchaseInvoicePdf(
          agreement: agreement(paid: paid),
          vehicle: vehicle,
          companyDetails: company,
        );
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
        expect(bytes.length, greaterThan(3000));
        if (paid == 20000) await _saveQa('purchase-invoice-example.pdf', bytes);
      }
    },
  );

  test(
    'handles long seller names and notes continuing on more pages',
    () async {
      final bytes = await generateCarPurchaseInvoicePdf(
        agreement: agreement(long: true),
        vehicle: vehicle,
        companyDetails: company,
      );
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(4000));
      await _saveQa('purchase-invoice-long-example.pdf', bytes);
    },
  );

  test(
    'supports optional company letterhead without external fetching',
    () async {
      final pixel = pw.MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
        ),
      );
      final bytes = await generateCarPurchaseInvoicePdf(
        agreement: agreement(),
        vehicle: vehicle,
        companyDetails: const {
          'company_name': 'Example Vehicle Trading LLC',
          'owner_address': 'Example Business Centre, Dubai',
          'owner_phone': '+971 00 000 0000',
        },
        headerImage: pixel,
        footerImage: pixel,
      );
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(3000));
      await _saveQa('purchase-invoice-letterhead-example.pdf', bytes);
    },
  );

  test('rejects zero or invalid purchase price and overpayment', () async {
    for (final invalid in [
      agreement(amount: 0, paid: 0),
      agreement(amount: -2, paid: 0),
      agreement(paid: -1),
      agreement(paid: 90000),
      agreement(amount: double.infinity),
      agreement(paid: double.nan),
    ]) {
      await expectLater(
        generateCarPurchaseInvoicePdf(
          agreement: invalid,
          vehicle: vehicle,
          companyDetails: company,
        ),
        throwsArgumentError,
      );
    }
  });
}

Future<void> _saveQa(String name, List<int> bytes) async {
  final output = Platform.environment['PURCHASE_PDF_QA_DIR'];
  if (output == null || output.isEmpty) return;
  final directory = await Directory(output).create(recursive: true);
  await File('${directory.path}/$name').writeAsBytes(bytes);
}
