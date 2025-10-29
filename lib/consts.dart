import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/text_button.dart';

// String backendURI = 'https://datahubai-backend.onrender.com';
// String backendTestURI = 'https://datahubai-backend.onrender.com';
String backendTestURI = 'http://127.0.0.1:8000';
// String backendTestURI = "http://10.0.2.2:8000";
String webSocketURL = "ws://localhost:8000/ws";
final formatter = CurrencyInputFormatter();

IconButton dateRange({
  required BuildContext context,
  required TextEditingController date,
}) {
  return IconButton(
    onPressed: () async {
      selectDateContext(context, date);
    },
    icon: const Icon(Icons.date_range),
  );
}

var fontStyleForAppBar = TextStyle(
  fontSize: 20,
  color: Colors.grey.shade700,
  fontWeight: FontWeight.bold,
);
var fontStyleForScreenNameUsedInButtons = const TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
var fontStyleForTableHeader = TextStyle(
  color: Colors.grey[700],
  fontWeight: FontWeight.bold,
  fontSize: 12,
);
var iconStyleForTableHeaderDown = Icon(
  Icons.keyboard_arrow_down,
  color: Colors.grey.shade700,
);
var iconStyleForTableHeaderUp = Icon(
  Icons.keyboard_arrow_up,
  color: Colors.grey.shade700,
);
var regTextStyle = TextStyle(
  color: Colors.grey.shade700,
  fontWeight: FontWeight.w500,
);
var userNameStyle = const TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontSize: 16,
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue,
);
var footerTextStylr = TextStyle(
  color: Colors.grey.shade700,
  fontWeight: FontWeight.bold,
  fontSize: 12,
);

var hintMarkTestStyle = TextStyle(
  color: Colors.grey.shade700,
  fontWeight: FontWeight.bold,
);

var fontStyleForElevatedButtons = const TextStyle(fontWeight: FontWeight.bold);

var paddingForButtons = const EdgeInsets.symmetric(horizontal: 16);

Color colorForNameInCards = const Color(0xFF00695C);

var newButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var capitalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff3D365C),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
var coutstandingButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff7C4585),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
var cgeneralExpensesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xffC95792),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var soldButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var isNotPressedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var new2ButtonStyle = ElevatedButton.styleFrom(
  textStyle: fontStyleForElevatedButtons,
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.green,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var postButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.teal,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var clearVariablesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.brown,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var cancelButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var cancelJobButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.red,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var internalNotesButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xffFA812F),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var inspectionFormButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff034C53),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var copyJobButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff7D1C4A),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var creatJobOrQuotationButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff393E46),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var innvoiceItemsButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.teal,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var openPDFButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var viewButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var editButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
var historyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueGrey,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
var activeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff9ACBD0),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var inActiveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff09122C),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var publicButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff16C47F),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var privateButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff123524),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var deleteButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var closeButtonStyle = ElevatedButton.styleFrom(
  padding: paddingForButtons,
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.red,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var approveButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xffD2665A),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var readyButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  backgroundColor: Colors.grey.shade300,
  foregroundColor: const Color(0xff7886C7),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var welcomButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
var logoutButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff3A6D8C),
  foregroundColor: Colors.white,
  padding: paddingForButtons,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(60, 40),
);

var addButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var nextButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[300],
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var selectButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepPurple[200],
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var loginButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var newCompannyButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: secColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);

var allButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff328E6E),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.all(8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var todayButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff94B4C1),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.all(8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);
var thisMonthButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff547792),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.all(8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);
var thisYearButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff213448),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.all(8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(40, 40),
);

var homeButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xffFA812F),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: const Size(100, 40),
);
final List<Color> cardColors = [
  const Color(0xFFFFF3E0), // Light orange
  const Color(0xFFFFF9C4), // Light yellow
  const Color(0xFFE1F5FE), // Light blue
  const Color(0xFFE8F5E9), // Light green
  const Color(0xFFF3E5F5), // Light purple
  const Color(0xFFFFEBEE), // Light red
  const Color(0xFFFFFDE7), // Cream
  const Color(0xFFE0F7FA), // Light cyan
  const Color(0xFFF1F8E9), // Mint
  const Color(0xFFEDE7F6), // Lavender
  const Color(0xFFFFF8E1), // Peach
  const Color(0xFFE3F2FD), // Sky blue
  const Color(0xFFFFF0F0), // Pinkish white
  const Color(0xFFFBE9E7), // Light coral
  const Color(0xFFF9FBE7), // Lemon chiffon
  // 🔽 Additional colors
  const Color(0xFFE0F2F1), // Aqua green
  const Color(0xFFFCE4EC), // Soft pink
  const Color(0xFFD1C4E9), // Pale violet
  const Color(0xFFF8BBD0), // Pastel rose
  const Color(0xFFDCEDC8), // Pale lime
  const Color(0xFFFFF9E6), // Light vanilla
  const Color(0xFFE3FCEC), // Light mint
  const Color(0xFFF0F4C3), // Light lime
  const Color(0xFFFAFAFA), // Almost white
  const Color(0xFFEFEBE9), // Warm beige
];

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

int? monthNameToNumber(String monthName) {
  const monthMap = {
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12,
  };

  return monthMap[monthName.toLowerCase()];
}

DocumentSnapshot<Object?>? getDocumentById(
  String id,
  List<DocumentSnapshot<Object?>> list,
) {
  try {
    return list.firstWhere((doc) => doc.id == id);
  } catch (e) {
    return null;
  }
}

var deleteIcon = const Icon(Icons.delete_forever, color: Colors.red);

var editIcon = const Icon(Icons.edit_note_rounded, color: Colors.blue);

var activeIcon = const Icon(Icons.check, color: Color(0xff9ACBD0));
var inActiveIcon = const Icon(
  Icons.horizontal_rule_rounded,
  color: Color(0xff09122C),
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

Text separator() => const Text('|', style: TextStyle(color: Colors.white));

Text point() {
  return Text(
    '•',
    style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold),
  );
}

double horizontalMarginForTable = 8;

var fontStyle1 = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
var fontStyle2 = TextStyle(
  color: Colors.grey[700],
  fontWeight: FontWeight.bold,
);
// var mainColor = const Color.fromARGB(255, 228, 200, 233);

double textFieldHeight = 35;
TextStyle textFieldFontStyle = const TextStyle(
  fontSize: 14,
  color: Colors.black,
);
TextStyle textFieldLabelStyle = TextStyle(
  color: Colors.grey.shade700,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

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
var textStyleForFavoritesCards = const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Color(0xffE9F5BE),
);

var textStyleForInspectionHints = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade700,
  fontWeight: FontWeight.bold,
);

var mainColor = const Color(0xff005f95);
// var mainColor = const Color(0xff27374D);
var secColor = const Color(0xff7E99A3);
// var secColor = const Color(0xff526D82);
var containerColor = const Color(0xffF5F5F5);
var textStyleForCardBottomBar = const TextStyle(color: Colors.blueGrey);
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
  return SizedBox(height: Get.height / space);
}

Row hintSection({required String hint, required Color color}) {
  return Row(
    spacing: 10,
    children: [
      Container(width: 15, height: 15, color: color),
      Text(hint, style: textStyleForInspectionHints),
    ],
  );
}

var closeButton = ElevatedButton(
  style: closeButtonStyle,
  onPressed: () {
    Get.back();
  },
  child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
);

// snack bar
void showSnackBar(String title, String body) {
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
    overlayBlur: 0,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    animationDuration: const Duration(milliseconds: 500),
    overlayColor: Colors.transparent, // 👈 allows click-through
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

    icon: const Icon(
      Icons.notifications_none_rounded,
      color: Colors.white,
      size: 28,
    ),
  );
}

// void showSnackBar(String title, String body) {
//     showDesktopToast(title,body);
//   }

Future<dynamic> alertMessage({
  required BuildContext context,
  required String content,
  required void Function() onPressed,
}) {
  return Get.defaultDialog(
    title: 'Alert',
    middleText: 'This is an alert message!',
    confirm: ElevatedButton(
      onPressed: () => Get.back(),
      child: const Text('OK'),
    ),
  );
}

Future<dynamic> alertDialog({
  required BuildContext context,
  required String content,
  required void Function() onPressed,
}) {
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
            child: const Text('Ok', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

// Future<void> alertDialog({
//   // BuildContext is required in Flutter to locate the dialog in the widget tree
//   required BuildContext context,
//   required String content,
//   required VoidCallback onPressed,
// }) {
//   return showDialog<void>(
//     context: context,
//     // Prevents closing the dialog by tapping outside of it
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         // Minimal rounding (matches the requested "little rounded" corners)
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

//         // Title consistent with the previous 'Alert'
//         title: const Text(
//           "Alert",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),

//         // Content body
//         content: Text(content, style: const TextStyle(fontSize: 14.0)),

//         actions: <Widget>[
//           // Cancel Button (Dismisses the dialog)
//           TextButton(
//             onPressed: () {
//               // Standard way to dismiss a dialog in Flutter
//               Navigator.of(context).pop();
//             },
//             child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//           ),

//           // Confirmation Button (Destructive/Primary Action)
//           TextButton(
//             // Execute the provided action
//             onPressed: () {
//               // 1. Dismiss the dialog first
//               Navigator.of(context).pop();
//               // 2. Execute the user's action
//               onPressed();
//             },
//             child: const Text(
//               'OK',
//               // Use a striking color (red) for destructive/important action
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

String textToDate(
  dynamic inputDate, {
  bool withTime = false,
  bool monthNameFirst = false,
}) {
  if (inputDate == null) return '';

  // Define the format based on the flags
  String format = monthNameFirst
      ? (withTime ? 'MMMM d, yyyy HH:mm:ss' : 'MMMM d, yyyy')
      : (withTime ? 'dd-MM-yyyy HH:mm:ss' : 'dd-MM-yyyy');

  final dateFormat = DateFormat(format);

  // Handle Firestore Timestamp
  if (inputDate is Timestamp) {
    return dateFormat.format(inputDate.toDate());
  }

  // Handle Dart DateTime
  if (inputDate is DateTime) {
    return dateFormat.format(inputDate);
  }

  // Handle String
  if (inputDate is String) {
    final raw = inputDate.trim();
    if (raw.isEmpty) return '';

    final ddMMyyyy = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (ddMMyyyy.hasMatch(raw)) {
      if (withTime) return '$raw 00:00:00';
      return raw;
    }

    try {
      final parsed = DateTime.parse(raw);
      return dateFormat.format(parsed);
    } catch (_) {
      try {
        final parsedStrict = DateFormat('yyyy-MM-dd').parseStrict(raw);
        return dateFormat.format(parsedStrict);
      } catch (e) {
        return '';
      }
    }
  }

  return '';
}

Container labelContainer({required Widget lable}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    alignment: Alignment.centerLeft,
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(5),
        topLeft: Radius.circular(5),
      ),
      color: secColor,
    ),
    child: lable,
  );
}

Decoration containerDecor = BoxDecoration(
  border: Border(
    left: BorderSide(color: secColor),
    right: BorderSide(color: secColor),
    bottom: BorderSide(color: secColor),
  ),
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(5),
    bottomRight: Radius.circular(5),
  ),
);

Widget textForDataRowInTable({
  required String text,
  double? maxWidth = 150,
  Color? color,
  bool isBold = false,
  double? fontSize,
  bool isSelectable = true,
  bool formatDouble = true, // New parameter with default true
}) {
  String formattedText = text;

  if (formatDouble) {
    double? parsedValue = double.tryParse(text);
    if (parsedValue != null) {
      formattedText = NumberFormat("#,##0.00").format(parsedValue);
    }
  }

  return Container(
    constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
    child: isSelectable
        ? SelectableText(
            formattedText,
            maxLines: 1,
            style: TextStyle(
              fontSize: fontSize,
              overflow: TextOverflow.ellipsis,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          )
        : Text(
            formattedText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
  );
}

Container statusBox(
  String status, {
  hieght = 30.0,
  width,
  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 16),
}) {
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
          : Colors.brown,
    ),
    height: hieght,
    width: width,
    padding: padding,
    child: Text(status, style: const TextStyle(color: Colors.white)),
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

void openImageViewer(List imageUrls, int index) {
  Get.toNamed('/imageViewer', arguments: {'images': imageUrls, 'index': index});
}

// Helper to get MIME type from file extension
String? getMimeTypeFromExtension(String extension) {
  const mimeTypes = {
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'txt': 'text/plain',
  };
  return mimeTypes[extension.toLowerCase()];
}

// Widget closeIcon() {
//   return IconButton(
//     visualDensity: VisualDensity.compact,
//     onPressed: () {
//       Get.back();
//     },
//     icon: const Icon(Icons.close, color: Colors.white),
//   );
// }

Widget closeIcon() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ClickableHoverText(
      onTap: () {
        Get.back();
      },
      text: "⨉",
    ),
  );
}

String? convertDateToIson(String date) {
  if (date.isEmpty) {
    return null;
  }
  final parsedDate = format.parse(date);
  final isoDate = parsedDate.toIso8601String();
  return isoDate;
}

// bool isBeforeToday(String dateStr) {
//   if (dateStr.isEmpty) return false;
//   print(dateStr);

//   // List of possible date formats
//   final formats = [
//   // --- Date only ---
//   DateFormat("dd-MM-yyyy"),
//   DateFormat("yyyy-MM-dd"),
//   DateFormat("MM/dd/yyyy"),
//   DateFormat("dd/MM/yyyy"),
//   DateFormat("yyyy/MM/dd"),
//   DateFormat("yyyyMMdd"),
//   DateFormat("dd MMM yyyy"),
//   DateFormat("MMM dd, yyyy"),

//   // --- Date + Time (24-hour) ---
//   DateFormat("dd-MM-yyyy HH:mm"),
//   DateFormat("dd-MM-yyyy HH:mm:ss"),
//   DateFormat("dd-MM-yyyy HH:mm:ss.SSS"), // with milliseconds
//   DateFormat("yyyy-MM-dd HH:mm"),
//   DateFormat("yyyy-MM-dd HH:mm:ss"),
//   DateFormat("yyyy-MM-dd HH:mm:ss.SSS"), // with milliseconds
//   DateFormat("MM/dd/yyyy HH:mm"),
//   DateFormat("MM/dd/yyyy HH:mm:ss"),
//   DateFormat("MM/dd/yyyy HH:mm:ss.SSS"),
//   DateFormat("dd/MM/yyyy HH:mm"),
//   DateFormat("dd/MM/yyyy HH:mm:ss"),
//   DateFormat("dd/MM/yyyy HH:mm:ss.SSS"),

//   // --- Date + Time (12-hour with AM/PM) ---
//   DateFormat("dd-MM-yyyy hh:mm a"),
//   DateFormat("dd-MM-yyyy hh:mm:ss a"),
//   DateFormat("yyyy-MM-dd hh:mm a"),
//   DateFormat("yyyy-MM-dd hh:mm:ss a"),
//   DateFormat("MM/dd/yyyy hh:mm a"),
//   DateFormat("MM/dd/yyyy hh:mm:ss a"),
//   DateFormat("dd/MM/yyyy hh:mm a"),
//   DateFormat("dd/MM/yyyy hh:mm:ss a"),

//   // --- With month name + time ---
//   DateFormat("dd MMM yyyy HH:mm"),
//   DateFormat("dd MMM yyyy HH:mm:ss"),
//   DateFormat("dd MMM yyyy HH:mm:ss.SSS"),
//   DateFormat("MMM dd, yyyy HH:mm"),
//   DateFormat("MMM dd, yyyy hh:mm a"),
// ];

//   DateTime? inputDate;

//   for (var format in formats) {
//     try {
//       inputDate = format.parseStrict(dateStr);
//       break; // parsed successfully, exit loop
//     } catch (_) {
//       continue; // try next format
//     }
//   }

//   if (inputDate == null) {
//     // Could not parse the date
//     return false;
//   }

//   DateTime today = DateTime.now();
//   DateTime todayOnly = DateTime(today.year, today.month, today.day);

//   return inputDate.isBefore(todayOnly);
// }

bool isBeforeToday(String dateStr) {
  if (dateStr.trim().isEmpty) return false;

  dateStr = dateStr.trim();

  // ✅ 1. Detect the format quickly using simple regex checks
  String? pattern;

  // --- ISO / MySQL formats ---
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
    pattern = "yyyy-MM-dd";
  } else if (RegExp(
    r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2}(\.\d{3})?)?$',
  ).hasMatch(dateStr)) {
    pattern = "yyyy-MM-dd HH:mm:ss.SSS";
  }
  // --- Slash-separated formats ---
  else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
    pattern = "dd/MM/yyyy";
  } else if (RegExp(
    r'^\d{2}/\d{2}/\d{4} \d{2}:\d{2}(:\d{2})?$',
  ).hasMatch(dateStr)) {
    pattern = "dd/MM/yyyy HH:mm:ss";
  }
  // --- Dash-separated European style ---
  else if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(dateStr)) {
    pattern = "dd-MM-yyyy";
  } else if (RegExp(
    r'^\d{2}-\d{2}-\d{4} \d{2}:\d{2}(:\d{2})?$',
  ).hasMatch(dateStr)) {
    pattern = "dd-MM-yyyy HH:mm:ss";
  }
  // --- With month name ---
  else if (RegExp(r'^\d{2} [A-Za-z]{3,} \d{4}').hasMatch(dateStr)) {
    pattern = "dd MMM yyyy";
  } else if (RegExp(r'^[A-Za-z]{3,} \d{2}, \d{4}').hasMatch(dateStr)) {
    pattern = "MMM dd, yyyy";
  }
  // --- Compact style like 20240202 ---
  else if (RegExp(r'^\d{8}$').hasMatch(dateStr)) {
    pattern = "yyyyMMdd";
  }
  // --- If time + AM/PM ---
  else if (RegExp(r'(AM|PM)$', caseSensitive: false).hasMatch(dateStr)) {
    if (dateStr.contains('-')) {
      pattern = "dd-MM-yyyy hh:mm:ss a";
    } else if (dateStr.contains('/')) {
      pattern = "dd/MM/yyyy hh:mm:ss a";
    } else {
      pattern = "yyyy-MM-dd hh:mm:ss a";
    }
  }

  // ✅ 2. Parse once using detected pattern
  DateTime? inputDate;
  try {
    if (pattern != null) {
      inputDate = DateFormat(pattern).parse(dateStr);
    } else {
      // fallback: try ISO8601 auto parser
      inputDate = DateTime.tryParse(dateStr);
    }
  } catch (_) {
    return false;
  }

  if (inputDate == null) return false;

  // ✅ 3. Compare only the date parts (ignore time)
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final inputDay = DateTime(inputDate.year, inputDate.month, inputDate.day);

  return inputDay.isBefore(today);
}

var loadingProcess = SizedBox(
  height: 20,
  width: 20,
  child: CircularProgressIndicator(strokeWidth: 2, color: mainColor),
);
Container carLogo(String? logo) {
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey, width: 2),
    ),
    child: (logo != null && logo.isNotEmpty)
        ? ClipOval(
            child: Image.network(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 24,
                  color: Colors.grey,
                );
              },
            ),
          )
        : const Icon(Icons.image, size: 24, color: Colors.grey),
  );
}

String getdataName(String id, Map allData, {title = 'name'}) {
  try {
    final data = allData.entries.firstWhere((data) => data.key == id);
    return data.value[title];
  } catch (e) {
    return '';
  }
}

Map getDaysInMonth(String monthName) {
  // Map of lowercase month names to their respective numeric values.
  const monthMap = {
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12,
  };

  final key = monthName.toLowerCase();
  if (!monthMap.containsKey(key)) {
    throw ArgumentError('Invalid month name: $monthName');
  }

  final month = monthMap[key]!;
  final year = DateTime.now().year;

  // DateTime(year, month + 1, 0) is the “zero‑th” day of the next month,
  // which resolves to the last day of [month].
  final lastDay = DateTime(year, month + 1, 0).day;
  return {
    for (var day = 1; day <= lastDay; day++)
      day.toString(): {'name': day.toString()},
  };
}

String monthNumberToName(int month) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return monthNames[month - 1];
}

DateFormat format = DateFormat("dd-MM-yyyy");

RxMap allStatus = RxMap({
  '1': {'name': 'New'},
  '2': {'name': 'Posted'},
  '3': {'name': 'Cancelled'},
});

bool normalizeDate(String input, TextEditingController date) {
  final raw = input.trim();
  if (raw.isEmpty) return false;

  // 1) جرب الصيغ المنفصلة بشرطات أو شرط مائل أو نقاط
  final sepPattern = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})$');
  final sepMatch = sepPattern.firstMatch(raw);
  if (sepMatch != null) {
    final d = int.tryParse(sepMatch.group(1)!)!;
    final m = int.tryParse(sepMatch.group(2)!)!;
    final y = int.tryParse(sepMatch.group(3)!)!;
    date.text = _formatIfValid(d, m, y);
    if (date.text == '') {
      return false;
    }
    return true;
  }

  // 2) جرب الصيغ بدون فاصل (سبعة أو ثمانية أرقام)
  final noSepPattern = RegExp(r'^(\d{1,2})(\d{1,2})(\d{4})$');
  final noSepMatch = noSepPattern.firstMatch(raw);
  if (noSepMatch != null) {
    final d = int.tryParse(noSepMatch.group(1)!)!;
    final m = int.tryParse(noSepMatch.group(2)!)!;
    final y = int.tryParse(noSepMatch.group(3)!)!;
    date.text = _formatIfValid(d, m, y);
    if (date.text == '') {
      return false;
    }
    return true;
  }

  // 3) فشل كل المحاولات
  date.text = '';
  return false;
}

/// يتأكد إن اليوم/الشهر/السنة يولّدوا تاريخ صالح، ويعيده بصيغة "dd-MM-yyyy"
String _formatIfValid(int day, int month, int year) {
  try {
    final dt = DateTime(year, month, day);
    // تأكد إنه فعلاً نفس القيم (مثلاً 31-02-2025 ينتج مارس أو يتعدى)
    if (dt.year == year && dt.month == month && dt.day == day) {
      return DateFormat('dd-MM-yyyy').format(dt);
    }
  } catch (_) {}
  return '';
}

Future<void> selectDateContext(
  BuildContext context,
  TextEditingController date,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    date.text = textToDate(picked.toString());
  }
}

String cloudinaryThumbnail(
  String originalUrl, {
  int? width,
  int? height,
  int quality = 80,
  bool fill = false, // if true, it will crop, else keep aspect ratio
}) {
  if (!originalUrl.contains("/upload/")) {
    throw ArgumentError("Not a valid Cloudinary URL");
  }

  // Build transformation dynamically
  final size = [
    if (width != null) "w_$width",
    if (height != null) "h_$height",
    "q_$quality",
    fill ? "c_fill" : "c_fit", // choose fit or fill
  ].join(",");

  return originalUrl.replaceFirst("/upload/", "/upload/$size/");
}

// ///////////////////////////////////////
final secureStorage = const FlutterSecureStorage();
Helpers helper = Helpers();

Future<void> logout() async {
  try {
    final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
    final prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('$backendTestURI/auth/logout');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"refresh_token": refreshToken},
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      showSnackBar('Done', responseBody['message']);
      await secureStorage.delete(key: "refreshToken");
      await prefs.remove("accessToken");
      await prefs.remove("userEmail");
      await prefs.remove("companyId");
      await prefs.remove("userId");
      Get.offAllNamed('/');
    } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
      final refreshed = await helper.refreshAccessToken(refreshToken);
      if (refreshed == RefreshResult.success) {
        await logout();
      } else {
        await prefs.remove("accessToken");
        await prefs.remove("userEmail");
        await prefs.remove("companyId");
        await prefs.remove("userId");
        Get.offAllNamed('/');
      }
    } else if (response.statusCode == 401) {
      await prefs.remove("accessToken");
      await prefs.remove("userEmail");
      await prefs.remove("companyId");
      await prefs.remove("userId");
      Get.offAllNamed('/');
    } else {
      await prefs.remove("accessToken");
      await prefs.remove("userEmail");
      await prefs.remove("companyId");
      await prefs.remove("userId");
      Get.offAllNamed('/');
    }
  } catch (e) {
    showSnackBar('Alert', 'Can\'t logout');
  }
}
