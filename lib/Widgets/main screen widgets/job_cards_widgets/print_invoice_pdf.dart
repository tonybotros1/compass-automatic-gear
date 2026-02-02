import 'package:datahubai/Models/job%20cards/job_card_invoice_items_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../../../consts.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:recase/recase.dart';

import '../../../helpers.dart';

String formatNum(num? value, NumberFormat formatter) {
  if (value == null) return '';
  return formatter.format(value);
}

pw.Widget tableHeaderRow(String title, bool isNumber) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    child: pw.Text(
      title,
      style: fontStyleForPDFTableHeader,
      textAlign: isNumber ? pw.TextAlign.end : pw.TextAlign.start,
    ),
  );
}

pw.Widget _infoRow({required String title, required String value}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.SizedBox(
            // width: 60,
            child: pw.Text(title, style: fontStyleForPDFLable),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(value, style: fontStyleForPDFText, softWrap: true),
        ),
      ],
    ),
  );
}

pw.Widget buildCustomerInfoSection(
  String payType,
  String customerName,
  String customerEntityName,
  String customerEntityPhoneNumber,
  String invoiceCounter,
  String lpoCounter,
  String invoiceDate,
  String jobCardCounter,
  String jobCardDate,
  String carBrand,
  String carModel,
  String year,
  String color,
  String city,
  String plateNumber,
  String plateCode,
  String mileageOut,
  String vin,
  Map companyDetails,
  Map customerInformation,
  Map customerAddressInformation,
  bool isProformaInvoice,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const pw.BoxDecoration(color: PdfColors.black),
        child: pw.Text(
          isProformaInvoice
              ? 'PROFORMA INVOICE'
              : 'TAX INVOICE - ${payType.toUpperCase()}',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(16),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _infoRow(title: 'Customer Name:', value: customerName),
                  _infoRow(
                    title: 'Address:',
                    value:
                        """
${customerAddressInformation.containsKey('line') ? customerAddressInformation['line'] ?? '' : ''}
${customerAddressInformation.containsKey('city') ? customerAddressInformation['city'] ?? '' : ''}, ${customerAddressInformation.containsKey('country') ? customerAddressInformation['country'] ?? '' : ''}
                                  """,
                  ),
                  _infoRow(title: 'Contact Person:', value: customerEntityName),
                  _infoRow(title: 'Phone:', value: customerEntityPhoneNumber),
                  _infoRow(
                    title: 'Customer TRN:',
                    value: customerInformation.containsKey('trn')
                        ? customerInformation['trn'] ?? ''
                        : '',
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _infoRow(title: 'Invoice NO:', value: invoiceCounter),
                  _infoRow(title: 'LPO:', value: lpoCounter),

                  _infoRow(title: 'Date:', value: textToDate(invoiceDate)),
                  _infoRow(
                    title: 'Our Reference:',
                    value: '$jobCardCounter - ${textToDate(jobCardDate)}',
                  ),
                  _infoRow(
                    title: 'Car Details:',
                    value:
                        """$carBrand $carModel, $year, $color
Plate Number: $city $plateNumber $plateCode
Mileage: $mileageOut
VIN: $vin
                                    """,
                  ),
                  _infoRow(
                    title: 'Our TRN:',
                    value: companyDetails.containsKey('tax_number')
                        ? companyDetails['tax_number'] ?? ''
                        : '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget buildInvoiceTable(List<JobCardInvoiceItemsModel> items) {
  return pw.Table(
    columnWidths: const {
      0: pw.FlexColumnWidth(4),
      1: pw.FlexColumnWidth(1),
      2: pw.FlexColumnWidth(1),
      3: pw.FlexColumnWidth(1),
      4: pw.FlexColumnWidth(1),
      5: pw.FlexColumnWidth(1),
      6: pw.FlexColumnWidth(1),
    },
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: PdfColors.black),
        children: [
          tableHeaderRow('Description', false),
          tableHeaderRow('Qty', true),
          tableHeaderRow('Price', true),
          tableHeaderRow('Total', true),
          tableHeaderRow('Discount', true),
          tableHeaderRow('VAT', true),
          tableHeaderRow('Net', true),
        ],
      ),
      ...items.map(
        (e) => _buildTableRow(
          e.description ?? '',
          formatNum(e.quantity, priceFormat),
          formatNum(e.price, priceFormat),
          formatNum(e.total, priceFormat),
          formatNum(e.discount, priceFormat),
          formatNum(e.vat, priceFormat),
          formatNum(e.net, priceFormat),
        ),
      ),
      ..._buildEmptyRows(12 - items.length),
    ],
  );
}

List<pw.TableRow> _buildEmptyRows(int count) {
  return List.generate(
    count > 8
        ? 8
        : count < 0
        ? 0
        : count,
    (_) => pw.TableRow(
      children: List.generate(
        count,
        (_) =>
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
      ),
    ),
  );
}

pw.TableRow _buildTableRow(
  String description,
  String qty,
  String price,
  String total,
  String discount,
  String vat,
  String net,
) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(description, style: fontStyleForPDFText),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          qty,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          price,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          total,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          discount,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          vat,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          net,
          style: fontStyleForPDFText,
          textAlign: pw.TextAlign.end,
        ),
      ),
    ],
  );
}

pw.Widget buildTotalsSection(
  List totals,
  String jobWarrentyDays,
  String jobWarrentyEndDate,
  String jobNotes,
  Font cairoBold,
  Font cairoRegular,
  String currentCountryVAT,
  double net,
  bool isLastPage,
  String countryCurrency,
  String subunitName,
  String netInWords,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 16),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Warranty:', style: fontStyleForPDFLable),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      '[$jobWarrentyDays] Days, End on [${textToDate(jobWarrentyEndDate, monthNameFirst: true)}]',
                      style: fontStyleForPDFText,
                    ),
                  ],
                ),
                pw.Text(jobNotes, style: fontStyleForPDFLable),
              ],
            ),
            pw.Column(
              children: [
                pw.Text(
                  'الشركة غير مسؤولة عن اي أعطال تحدث نتيجة تغيير الزيت',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(font: cairoBold, fontSize: 8),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'The company is not responsible for any\n issue caused by gear oil change:',
                  style: fontStyleForPDFLable,
                ),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.5),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Warranty does not cover',
                            style: fontStyleForPDFLable,
                          ),
                          pw.Text(
                            'الضمان لا يشمل',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: cairoBold, fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Mixing oil with water',
                                style: fontStyleForPDFText,
                              ),
                              pw.Text(
                                'خلط الزيت مع الماء',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: cairoRegular,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Any electrical mallfunctions',
                                style: fontStyleForPDFText,
                              ),
                              pw.Text(
                                'أي أعطال كهربائية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: cairoRegular,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Misuse or alternate of repaired items',
                                style: fontStyleForPDFText,
                              ),
                              pw.Text(
                                'سوء الاستخدام أو تعديل القطع التي تم اصلاحها',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: cairoRegular,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Total : ', style: fontStyleForPDFLable),
                        pw.Container(
                          width: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          child: pw.Text(
                            isLastPage
                                ? formatNum(totals[0] ?? 0, priceFormat)
                                : "",
                            style: fontStyleForPDFText,
                            textAlign: pw.TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Discount : ', style: fontStyleForPDFLable),
                        pw.Container(
                          width: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          child: pw.Text(
                            isLastPage
                                ? formatNum(totals[3] ?? 0, priceFormat)
                                : '',
                            style: fontStyleForPDFText,
                            textAlign: pw.TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'VAT ($currentCountryVAT%) : ',
                          style: fontStyleForPDFLable,
                        ),
                        pw.Container(
                          width: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          child: pw.Text(
                            isLastPage
                                ? formatNum(totals[1] ?? 0, priceFormat)
                                : '',
                            style: fontStyleForPDFText,
                            textAlign: pw.TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Net : ', style: fontStyleForPDFLable),
                        pw.Container(
                          width: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          child: pw.Text(
                            isLastPage ? formatNum(net, priceFormat) : '',
                            style: fontStyleForPDFText,
                            textAlign: pw.TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(netInWords, style: fontStyleForPDFLable),
      ),
    ],
  );
}

pw.Widget buildSignatures(String companyName) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('For $companyName', style: fontStyleForPDFLable),
          pw.SizedBox(height: 20),
          pw.Text('_________________________'),
        ],
      ),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          pw.Text('Customer Signature', style: fontStyleForPDFLable),
          pw.SizedBox(height: 20),
          pw.Text('_________________________'),
        ],
      ),
    ],
  );
}

Future<String> convertNumberToWords(double number, String currencyId) async {
  Helpers helper = Helpers();

  Map nameAndSubunit = await helper.getCurrencyNameAndSubunit(currencyId);
  String currency = nameAndSubunit['currency_name'];
  String subunit = nameAndSubunit['subunit_name'];

  if (number % 1 == 0) {
    String words =
        'only ${NumberToWord().convert('en-in', number.toInt())} $currency';
    ReCase rc = ReCase(words);

    return rc.titleCase;
  } else {
    int integerPart = number.floor();
    int decimalPart = ((number - integerPart) * 100).round();
    String words =
        'only ${NumberToWord().convert('en-in', integerPart)} $currency';
    if (decimalPart > 0) {
      words +=
          ' point ${NumberToWord().convert('en-in', decimalPart)} $subunit';
    }
    ReCase rc = ReCase(words);
    words = rc.titleCase;
    return words;
  }
}
