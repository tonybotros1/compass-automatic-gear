import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/print_invoice_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../../../consts.dart';

pw.Widget infoRow({
  required String title,
  required String value,
  bool? isNumber = false,
  pw.Font? font
}) {
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
          child: pw.Text(
            value,
            style: fontStyleForPDFText,
            softWrap: true,
            textAlign: isNumber == true ? pw.TextAlign.end : null,
          ),
        ),
      ],
    ),
  );
}

pw.Widget numberInfoRow({required String title, required String value}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 60,
          child: pw.Text(title, style: fontStyleForPDFLable),
        ),
        pw.Container(
          width: 100,
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            value,
            style: fontStyleForPDFText,
            softWrap: true,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}

pw.Widget buildCustomerInfoSectionForDeliveryNote(
  String customerName,
  String customerEntityName,
  String customerEntityPhoneNumber,
  String invoiceDate,
  String jobCardCounter,
  String jobCardDate,
  String carBrand,
  String carModel,
  String plateNumber,
  Map companyDetails,
  Map customerInformation,
  Map customerAddressInformation,
  bool withPrice,
  List totals,
  String deliveryNote,
) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(16),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  infoRow(title: 'Customer Name:', value: customerName),
                  infoRow(
                    title: 'Address:',
                    value:
                        """
${customerAddressInformation.containsKey('line') ? customerAddressInformation['line'] ?? '' : ''}
${customerAddressInformation.containsKey('city') ? customerAddressInformation['city'] ?? '' : ''}, ${customerAddressInformation.containsKey('country') ? customerAddressInformation['country'] ?? '' : ''}
                                  """,
                  ),
                  infoRow(title: 'Contact Person:', value: customerEntityName),
                  infoRow(title: 'Phone:', value: customerEntityPhoneNumber),
                  infoRow(
                    title: 'Request No.:',
                    value: customerInformation.containsKey('trn')
                        ? customerInformation['trn'] ?? ''
                        : '',
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: withPrice
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        infoRow(
                          title: """Part No. &
Description:""",
                          value:
                              """$plateNumber
$deliveryNote
""",
                        ),
                        numberInfoRow(
                          title: 'Price:',
                          value: formatNum(totals[0], priceFormat),
                        ),
                        numberInfoRow(
                          title: 'VAT:',
                          value: formatNum(totals[3], priceFormat),
                        ),
                        numberInfoRow(
                          title: 'Total:',
                          value: formatNum(totals[2], priceFormat),
                        ),
                      ],
                    )
                  : pw.SizedBox(),
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget buildIDeliveryNoteTable(
  String jobDate,
  String brand,
  String plateNumber,
  String model,
  String year,
  String vin,
) {
  return pw.Table(
    columnWidths: const {
      0: pw.FlexColumnWidth(1),
      1: pw.FlexColumnWidth(1),
      2: pw.FlexColumnWidth(1),
      3: pw.FlexColumnWidth(1),
      4: pw.FlexColumnWidth(1),
    },
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: PdfColors.black),
        children: [
          tableHeaderRowForDeliveryNote('Job Date', false),
          tableHeaderRowForDeliveryNote('Car Brand', true),
          tableHeaderRowForDeliveryNote('Plate NO', true),
          tableHeaderRowForDeliveryNote('Model / Year', true),
          tableHeaderRowForDeliveryNote('VIN', true),
        ],
      ),
      _buildTableRowForDeliveryNote(
        jobDate,
        brand,
        plateNumber,
        model,
        year,
        vin,
      ),
    ],
  );
}

pw.TableRow _buildTableRowForDeliveryNote(
  String jobDate,
  String brand,
  String plateNumber,
  String mmodel,
  String year,
  String vin,
) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(jobDate, style: fontStyleForPDFText),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(brand, style: fontStyleForPDFText),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(plateNumber, style: fontStyleForPDFText),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text("$mmodel - $year", style: fontStyleForPDFText),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(vin, style: fontStyleForPDFText),
      ),
    ],
  );
}

pw.Widget tableHeaderRowForDeliveryNote(String title, bool isNumber) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    child: pw.Text(title, style: fontStyleForPDFTableHeader),
  );
}
