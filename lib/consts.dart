import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

var fontStyleForAppBar = TextStyle(
    fontSize: 20, color: Colors.grey.shade700, fontWeight: FontWeight.bold);
var fontStyleForScreenNameUsedInButtons = const TextStyle(
    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
var fontStyleForTableHeader = TextStyle(
    color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 12);
var iconStyleForTableHeaderDown =
    Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700);
var iconStyleForTableHeaderUp =
    Icon(Icons.keyboard_arrow_up, color: Colors.grey.shade700);
var regTextStyle =
    TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500);
var userNameStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    decoration: TextDecoration.underline,
    decorationColor: Colors.blue);
var footerTextStylr = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12);

var newButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var soldButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var new2ButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.green,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var postButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.teal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var clearVariablesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.brown,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var cancelButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var cancelJobButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var internalNotesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xffFA812F),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var inspectionFormButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff034C53),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var copyJobButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff7D1C4A),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var innvoiceItemsButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.teal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var openPDFButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var viewButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var editButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var historyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var activeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff9ACBD0),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var inActiveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff09122C),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var publicButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff16C47F),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var privateButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff123524),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var deleteButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var closeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(10, 40),
);

var approveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xffD2665A),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var readyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff7886C7),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var welcomButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var logoutButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff3A6D8C),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(60, 40),
);

var addButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var nextButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[300],
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var selectButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepPurple[200],
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var loginButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var newCompannyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: secColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var allButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xff328E6E),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var todayButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xff94B4C1),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var thisMonthButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xff547792),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var thisYearButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xff213448),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var screenPadding = const EdgeInsets.only(
  left: 14,
  right: 14,
  bottom: 10,
  top: 0,
);

String formatPhrase(String phrase) {
  return phrase.replaceAll(' ', '_');
}

double horizontalMarginForTable = 8;

var fontStyle1 =
    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
var fontStyle2 =
    TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold);
// var mainColor = const Color.fromARGB(255, 228, 200, 233);

double textFieldHeight = 35;
TextStyle textFieldFontStyle =
    const TextStyle(fontSize: 14, color: Colors.black);
TextStyle textFieldLabelStyle = TextStyle(
    color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold);

var textStyleForCardsLabels = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: secColor,
);

var textStyleForCardsLabelsCarBrandAndModel = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: mainColor,
);

var textStyleForCardsContents = const TextStyle(
  fontSize: 19,
  color: Colors.black54,
);

var textStyleForInspectionHints = TextStyle(
    fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.bold);

var mainColor = const Color(0xff005f95);
// var mainColor = const Color(0xff27374D);
var secColor = const Color(0xff7E99A3);
// var secColor = const Color(0xff526D82);
var containerColor = const Color(0xffF5F5F5);
var textStyleForCardBottomBar = TextStyle(color: Colors.blueGrey);
var iconColorForCardBottomBar = Colors.blueGrey;

// Color headerColor = Colors.blue.shade900;

// new colors
var mainColorForWeb = const Color(0xFFF4F4F8);

//=========================================================
var appBarColor = const Color(0xffEB5B00);

//=========================================================

const iconColor = Color(0xFF969BA9);
const menuSelectionColor = Color(0xffEA2027);
const backgroundColor2 = Color(0xFFFFFFFF);

Widget verticalSpace({int space = 20}) {
  return SizedBox(
    height: Get.height / space,
  );
}

Row hintSection({required String hint, required Color color}) {
  return Row(
    spacing: 10,
    children: [
      Container(
        width: 15,
        height: 15,
        color: color,
      ),
      Text(
        hint,
        style: textStyleForInspectionHints,
      )
    ],
  );
}

var closeButton = ElevatedButton(
    style: closeButtonStyle,
    onPressed: () {
      Get.back();
    },
    child: const Text(
      'Close',
      style: TextStyle(fontWeight: FontWeight.bold),
    ));

// snack bar
void showSnackBar(title, body) {
  Get.snackbar(
    title,
    body,
    snackPosition: SnackPosition.TOP,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.only(left: 20, bottom: 20),
    borderRadius: 10,
    backgroundColor: Colors.black87,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    maxWidth: 300,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    animationDuration: const Duration(milliseconds: 500),
  );
}

Future<dynamic> alertDialog(
    {required context,
    controller,
    required String content,
    required void Function() onPressed}) {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text("Alert"),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            isDefaultAction: true,
            onPressed: onPressed,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

// function to convert text to date and make the format dd-mm-yyyy
String textToDate(dynamic inputDate) {
  if (inputDate is String) {
    if (inputDate.isEmpty) {
      return '';
    }

    // Check if the input is already in dd-MM-yyyy format
    final RegExp dateFormatRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (dateFormatRegex.hasMatch(inputDate)) {
      return inputDate;
    }

    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(inputDate);
      return DateFormat("dd-MM-yyyy").format(parsedDate);
    } catch (e) {
      return ''; // Return empty string if parsing fails
    }
  } else if (inputDate is DateTime) {
    return DateFormat("dd-MM-yyyy").format(inputDate);
  }
  return ''; // Return empty string for unsupported types
}

Container labelContainer({
  required Widget lable,
}) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5), topLeft: Radius.circular(5)),
          color: secColor),
      child: lable);
}

Decoration containerDecor = BoxDecoration(
    border: Border(
      left: BorderSide(color: secColor),
      right: BorderSide(color: secColor),
      bottom: BorderSide(color: secColor),
    ),
    borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)));

Widget textForDataRowInTable({
  required String text,
  double? maxWidth = 150,
  Color? color,
  bool isBold = false,
  double? fontSize,
}) {
  // Try parsing the text as a double
  String formattedText = text;
  double? parsedValue = double.tryParse(text);

  if (parsedValue != null) {
    formattedText =
        NumberFormat("#,##0.00").format(parsedValue); // Formats as double
  }

  return Container(
    constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
    child: SelectableText(
      formattedText,
      maxLines: 1,
      style: TextStyle(
        fontSize: fontSize,
        overflow: TextOverflow.ellipsis,
        color: color,
        fontWeight: isBold ? FontWeight.bold : null,
      ),
    ),
  );
}

Container statusBox(String status, {hieght = 30.0, width}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(5),
        color: status == 'New'
            ? Colors.green
            : status == 'Posted' || status == 'Sold'
                ? Colors.teal
                : status == 'Cancelled' || status == 'R'
                    ? Colors.red
                    : status == 'Approved'
                        ? const Color(0xffD2665A)
                        : status == 'Ready' || status == 'D'
                            ? const Color(0xff7886C7)
                            : status == 'Closed' || status == 'Warranty'
                                ? Colors.black
                                : Colors.brown),
    height: hieght,
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      status,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

// final NumberFormat _formatter = NumberFormat("#,##0.00", "en_US");

// void _formatInput(dynamic value) {
//   if (value == null) return;

//   double? parsed;

//   if (value is num) {
//     parsed = value.toDouble();
//   } else if (value is String && value.trim().isNotEmpty) {
//     parsed = double.tryParse(value.replaceAll(',', ''));
//   }

//   if (parsed != null) {
//     final String formatted = _formatter.format(parsed);
//     _controller.value = TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: formatted.length),
//     );
//   }
// }
