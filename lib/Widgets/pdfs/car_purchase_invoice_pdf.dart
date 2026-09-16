import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Models/car trading/car_trade_model.dart';
import '../../Models/car trading/car_trading_purchase_agreement_model.dart';

/// Builds the English purchase document without fetching fonts or images.
/// The company is the buyer; agreement party details are the saved snapshot.
Future<Uint8List> generateCarPurchaseInvoicePdf({
  required CarTradingPurchaseAgreementModel agreement,
  required CarTradeModel vehicle,
  required Map<String, dynamic> companyDetails,
  pw.ImageProvider? headerImage,
  pw.ImageProvider? footerImage,
}) async {
  final total = agreement.amount ?? 0;
  final paid = agreement.aownpayment ?? 0;
  _validatePayment(total, paid);
  final currencyCode = _value(companyDetails['currency_code'], 'AED');
  final currencyName = _value(companyDetails['currency_name'], 'Dirhams');
  final subunitName = _value(companyDetails['subunit_name'], 'Fils');
  final companyName = _value(
    companyDetails['company_name'],
    _value(agreement.buyerName, 'Company'),
  );
  final companyAddress = _companyValue(companyDetails, const [
    'company_address',
    'address',
    'owner_address',
  ]);
  final companyPhone = _companyValue(companyDetails, const [
    'company_phone',
    'phone_number',
    'phone',
    'owner_phone',
  ]);
  final buyerName = _value(agreement.buyerName, companyName);
  final sellerName = _value(agreement.sellerName);
  final number = _value(agreement.agreementNumber);
  final date = agreement.agreementDate == null
      ? '-'
      : DateFormat('dd MMM yyyy', 'en_US').format(agreement.agreementDate!);
  final money = _formatMoney(total, currencyCode);
  final balance = (_minorUnits(total) - _minorUnits(paid)) / 100;
  final document = pw.Document(
    title: 'Purchase Invoice $number',
    author: companyName,
    subject: 'Vehicle purchase invoice',
  );
  const ink = PdfColor.fromInt(0xff203448);
  const light = PdfColor.fromInt(0xfff2f5f7);
  const muted = PdfColor.fromInt(0xff617080);
  const bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
  const headerHeight = 115.0;
  const footerHeight = 100.0;
  final textTheme = pw.ThemeData.withFont(
    base: pw.Font.helvetica(),
    bold: pw.Font.helveticaBold(),
  ).copyWith(defaultTextStyle: const pw.TextStyle(fontSize: 9));

  pw.Widget body(pw.Widget child) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 38),
    child: child,
  );

  pw.Widget section(String title) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
    child: pw.Text(title, style: bold.copyWith(fontSize: 10, color: ink)),
  );

  pw.Widget field(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 99,
          child: pw.Text(label, style: const pw.TextStyle(color: muted)),
        ),
        pw.Expanded(child: pw.Text(value)),
      ],
    ),
  );

  pw.Widget partyField(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 67,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8, color: muted),
          ),
        ),
        pw.Expanded(child: pw.Text(value)),
      ],
    ),
  );

  pw.Widget partyColumn(String title, List<pw.Widget> fields) => pw.Expanded(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: bold.copyWith(fontSize: 9, color: ink)),
        pw.SizedBox(height: 3),
        ...fields,
      ],
    ),
  );

  pw.Widget cell(
    String text, {
    bool heading = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    child: pw.Text(
      text,
      textAlign: align,
      style: heading ? bold.copyWith(color: ink) : null,
    ),
  );

  pw.Widget signature(String title, String name) => pw.Expanded(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: bold.copyWith(color: ink)),
        pw.SizedBox(height: 3),
        pw.Text(name),
        pw.SizedBox(height: 12),
        pw.Container(height: 0.6, color: muted),
        pw.SizedBox(height: 3),
        pw.Text('Signature / stamp', style: const pw.TextStyle(color: muted)),
        pw.SizedBox(height: 5),
        pw.Text('Date: ____________________'),
      ],
    ),
  );

  final vehicleName = [
    vehicle.carBrand,
    vehicle.carModel,
    vehicle.trim,
  ].where((part) => part != null && part.trim().isNotEmpty).join(' ');
  final details = <String>[
    _value(vehicleName, 'Motor vehicle'),
    'Year: ${_value(vehicle.year)}',
    'Exterior color: ${_value(vehicle.colorOut)}',
    'VIN / chassis no.: ${_value(vehicle.vin)}',
    'Engine no.: ${_value(vehicle.engineNumber)}',
    'Mileage: ${vehicle.mileage == null ? '-' : '${NumberFormat('#,##0', 'en_US').format(vehicle.mileage)} km'}',
  ];
  final terms = <String>[
    'The seller declares that they are entitled to sell the vehicle described '
        'above and that it is free of liens, finance obligations and third-party '
        'claims, except as expressly recorded in this invoice.',
    'This vehicle is purchased for resale.',
    'On signing, the seller acknowledges only the amount recorded as paid '
        'above. Any balance shown remains payable.',
    'By signing below, the seller and the company representative confirm the '
        'vehicle details, purchase price and payment details recorded in this '
        'invoice. Each party may retain a copy.',
  ];

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      theme: textTheme,
      header: (context) => headerImage != null
          ? pw.SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: pw.Image(
                headerImage,
                fit: pw.BoxFit.fitWidth,
                alignment: pw.Alignment.topCenter,
              ),
            )
          : pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(38, 20, 38, 0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    companyName,
                    style: bold.copyWith(fontSize: 17, color: ink),
                  ),
                  if (companyAddress.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Text(companyAddress),
                    ),
                  if (companyPhone.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 3),
                      child: pw.Text('Tel: $companyPhone'),
                    ),
                  pw.SizedBox(height: 7),
                  pw.Container(height: 1.4, color: ink),
                  pw.SizedBox(height: 9),
                ],
              ),
            ),
      footer: (context) => pw.Column(
        children: [
          body(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Purchase invoice $number',
                  style: const pw.TextStyle(fontSize: 8, color: muted),
                ),
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 8, color: muted),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          if (footerImage != null)
            pw.SizedBox(
              height: footerHeight,
              width: double.infinity,
              child: pw.Image(
                footerImage,
                fit: pw.BoxFit.fitWidth,
                alignment: pw.Alignment.bottomCenter,
              ),
            )
          else
            pw.SizedBox(height: 18),
        ],
      ),
      build: (context) => <pw.Widget>[
        pw.Text(
          'PURCHASE INVOICE',
          style: bold.copyWith(fontSize: 18, color: ink),
        ),
        pw.SizedBox(height: 7),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Invoice no.: $number', style: bold),
            pw.Text('Date: $date', style: bold),
          ],
        ),
        section('PARTIES'),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            partyColumn('BUYER / COMPANY', [
              partyField('Name', buyerName),
              if (_value(agreement.buyerID, '').isNotEmpty)
                partyField('ID / licence', agreement.buyerID!.trim()),
              if (_value(agreement.buyerPhone, '').isNotEmpty)
                partyField('Phone', agreement.buyerPhone!.trim()),
              if (_value(agreement.buyerEmail, '').isNotEmpty)
                partyField('Email', agreement.buyerEmail!.trim()),
            ]),
            pw.SizedBox(width: 28),
            partyColumn('SELLER', [
              partyField('Name', sellerName),
              partyField('ID / licence', _value(agreement.sellerID)),
              partyField('Phone', _value(agreement.sellerPhone)),
              if (_value(agreement.sellerEmail, '').isNotEmpty)
                partyField('Email', agreement.sellerEmail!.trim()),
            ]),
          ],
        ),
        section('VEHICLE PURCHASE'),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.6),
          columnWidths: const {
            0: pw.FixedColumnWidth(42),
            1: pw.FlexColumnWidth(),
            2: pw.FixedColumnWidth(49),
            3: pw.FixedColumnWidth(108),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: light),
              children: [
                cell('S.No.', heading: true),
                cell('Description', heading: true),
                cell('Qty.', heading: true, align: pw.TextAlign.center),
                cell(
                  'Price ($currencyCode)',
                  heading: true,
                  align: pw.TextAlign.right,
                ),
              ],
            ),
            pw.TableRow(
              children: [
                cell('1', align: pw.TextAlign.center),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(9),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < details.length; i++)
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                            bottom: i == details.length - 1 ? 0 : 5,
                          ),
                          child: pw.Text(
                            details[i],
                            style: i == 0 ? bold : null,
                          ),
                        ),
                    ],
                  ),
                ),
                cell('1', align: pw.TextAlign.center),
                cell(_formatNumber(total), align: pw.TextAlign.right),
              ],
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          color: light,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('TOTAL PURCHASE PRICE', style: bold),
              pw.Text(money, style: bold.copyWith(fontSize: 12)),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Amount in words: ${carPurchaseAmountInWords(total, currencyName: currencyName, subunitName: subunitName)}',
        ),
        section('PAYMENT'),
        field('Payment method', _paymentMethodLabel(agreement.paymentMethod)),
        field('Amount paid', _formatMoney(paid, currencyCode)),
        field('Balance payable', _formatMoney(balance, currencyCode)),
        section('TERMS AND DECLARATIONS'),
        for (var i = 0; i < terms.length; i++)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              '${i + 1}. ${terms[i]}',
              style: const pw.TextStyle(lineSpacing: 1.2),
            ),
          ),
        if (_value(agreement.note, '').isNotEmpty) ...[
          section('ADDITIONAL NOTES'),
          // Bound each text block so a long note can continue across pages.
          for (final paragraph in _noteParagraphs(agreement.note!))
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(
                paragraph,
                style: const pw.TextStyle(lineSpacing: 1.2),
              ),
            ),
        ],
        pw.SizedBox(height: 5),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            signature('SELLER', sellerName),
            pw.SizedBox(width: 35),
            signature('FOR THE BUYER / COMPANY', buyerName),
          ],
        ),
      ].map(body).toList(),
    ),
  );
  return document.save();
}

String _value(dynamic value, [String fallback = '-']) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

String _companyValue(Map<String, dynamic> company, List<String> keys) {
  final contactDetails = company['contact_details'];
  for (final source in [company, if (contactDetails is Map) contactDetails]) {
    for (final key in keys) {
      final value = source[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
  }
  return '';
}

String _paymentMethodLabel(String value) => switch (value) {
  'cash' => 'Cash',
  'bank_transfer' => 'Bank transfer',
  'cheque' => 'Cheque',
  'other' => 'Other (see notes)',
  _ => 'Not specified',
};

void _validatePayment(double total, double paid) {
  if (!total.isFinite || total <= 0 || _minorUnits(total) <= 0) {
    throw ArgumentError.value(
      total,
      'amount',
      'Purchase price must be positive.',
    );
  }
  if (!paid.isFinite || paid < 0 || paid > total) {
    throw ArgumentError.value(
      paid,
      'amountPaid',
      'Amount paid must be between zero and the purchase price.',
    );
  }
}

/// Decimal rounding avoids binary floating-point errors such as 1.005 -> 1.00.
/// Both printed figures and words use exactly the same rounded minor units.
int _minorUnits(num amount) {
  if (!amount.isFinite || amount < 0 || amount >= 1e13) {
    throw ArgumentError.value(
      amount,
      'amount',
      'Expected a finite non-negative amount below 10 trillion.',
    );
  }
  final parts = amount.toString().toLowerCase().split('e');
  final exponent = parts.length == 2 ? int.parse(parts[1]) : 0;
  final decimal = parts.first.split('.');
  final fraction = decimal.length == 2 ? decimal[1] : '';
  final digits = BigInt.parse('${decimal[0]}$fraction');
  final shift = 2 + exponent - fraction.length;
  if (shift >= 0) return (digits * BigInt.from(10).pow(shift)).toInt();
  final divisor = BigInt.from(10).pow(-shift);
  final rounded =
      digits ~/ divisor +
      ((digits % divisor) * BigInt.two >= divisor ? BigInt.one : BigInt.zero);
  return rounded.toInt();
}

String _formatNumber(num amount) =>
    NumberFormat('#,##0.00', 'en_US').format(_minorUnits(amount) / 100);

String _formatMoney(num amount, String currencyCode) =>
    '$currencyCode ${_formatNumber(amount)}';

/// English words for the same two-decimal amount printed on the invoice.
String carPurchaseAmountInWords(
  num amount, {
  String currencyName = 'Dirhams',
  String subunitName = 'Fils',
}) {
  final minor = _minorUnits(amount);
  final whole = minor ~/ 100;
  final fraction = minor % 100;
  final words =
      '${_integerWords(whole)} ${_value(currencyName, 'Dirhams')}'
      '${fraction == 0 ? '' : ' and ${_integerWords(fraction)} ${_value(subunitName, 'Fils')}'} only';
  return words[0].toUpperCase() + words.substring(1);
}

String _integerWords(int value) {
  const small = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen',
  ];
  const tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
  ];
  if (value < 20) return small[value];
  if (value < 100) {
    return '${tens[value ~/ 10]}${value % 10 == 0 ? '' : '-${small[value % 10]}'}';
  }
  if (value < 1000) {
    return '${small[value ~/ 100]} hundred${value % 100 == 0 ? '' : ' and ${_integerWords(value % 100)}'}';
  }
  const scales = <int, String>{
    1000000000000: 'trillion',
    1000000000: 'billion',
    1000000: 'million',
    1000: 'thousand',
  };
  for (final scale in scales.entries) {
    if (value >= scale.key) {
      final rest = value % scale.key;
      return '${_integerWords(value ~/ scale.key)} ${scale.value}${rest == 0 ? '' : '${rest < 100 ? ' and ' : ' '}${_integerWords(rest)}'}';
    }
  }
  throw StateError('Unsupported amount.');
}

Iterable<String> _noteParagraphs(String note) sync* {
  for (final paragraph in note.trim().split(RegExp(r'\n+'))) {
    var current = '';
    for (final word in paragraph.split(RegExp(r'\s+'))) {
      if (current.length + word.length > 350 && current.isNotEmpty) {
        yield current;
        current = '';
      }
      current = current.isEmpty ? word : '$current $word';
    }
    if (current.isNotEmpty) yield current;
  }
}
