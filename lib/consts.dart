import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

var fontStyleForAppBar = TextStyle(
    fontSize: 20, color: Colors.grey.shade700, fontWeight: FontWeight.bold);
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

var saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var clearVariablesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.brown,
  foregroundColor: Colors.white,
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

var internalNotesButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xffFA812F),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var innvoiceItemsButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.teal,
  foregroundColor: Colors.white,
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

var welcomButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);
var logoutButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xff3A6D8C),
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

var screenPadding = const EdgeInsets.only(
  left: 14,
  right: 14,
  bottom: 10,
  top: 0,
);

var fontStyle1 = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
var fontStyle2 =
    TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold);
// var mainColor = const Color.fromARGB(255, 228, 200, 233);

var mainColor = const Color(0xff005f95);
// var mainColor = const Color(0xff27374D);
var secColor = const Color(0xff7E99A3);
// var secColor = const Color(0xff526D82);
var containerColor = const Color(0xffF5F5F5);

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

// snack bar
void showSnackBar(title, body) {
  Get.snackbar(
    title,
    body,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.grey,
    colorText: Colors.white,
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
textToDate(inputDate) {
  if (inputDate is String) {
    if (inputDate == '') {
      return '';
    }
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(inputDate);
    String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);

    return formattedDate;
  } else if (inputDate is DateTime) {
    String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);

    return formattedDate;
  }
}

Container labelContainer({
  required Widget lable,
}) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5), topLeft: Radius.circular(5)),
          color: mainColor),
      child: lable);
}

Decoration containerDecor = BoxDecoration(
    border: Border(
      left: BorderSide(color: mainColor),
      right: BorderSide(color: mainColor),
      bottom: BorderSide(color: mainColor),
    ),
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)));

class ImagePickerService {
  static Future<void> pickImage(
      Rx<Uint8List?> imageBytes, RxBool flagSelectedError) async {
    try {
      flagSelectedError.value = false;
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files.first;
          final reader = html.FileReader();

          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) async {
            if (reader.result != null) {
              imageBytes.value = reader.result as Uint8List;
            }
          });
        }
      });
    } catch (e) {
      flagSelectedError.value = true; // Handle error
    }
  }
}

class FilePickerService {
  static Future<void> pickFile(
      Rx<Uint8List?> fileBytes, RxString fileType, RxString fileName) async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '*/*'; // Accept all file types
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files.first;
          fileName.value = file.name;
          final reader = html.FileReader();

          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) async {
            if (reader.result != null) {
              fileBytes.value = reader.result as Uint8List;
              fileType.value = file.type; // Store file type
            }
          });
        }
      });
    } catch (e) {
      //
    }
  }

  static Future<void> openFile(String? fileUrl) async {
    try {
      if (fileUrl == null || fileUrl.isEmpty) return;

      final isPdf = await _isPdfFile(fileUrl);

      if (isPdf) {
        // Open PDF in new window
        final newWindow = html.window.open('', '_blank');
        newWindow.location.href = fileUrl;
      } else {
        // Download logic with proper filename handling
        final fileName = _getFileNameFromUrl(fileUrl);
        final mimeType = await _getContentType(fileUrl);
        final extension = _getExtensionFromMimeType(mimeType) ?? 'bin';

        final anchor = html.AnchorElement(href: fileUrl)
          ..download =
              fileName.contains('.') ? fileName : '$fileName.$extension'
          ..style.display = 'none';

        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
      }
    } catch (e) {
      html.window.open(fileUrl ?? '', '_blank');
    }
  }

// Helper to extract filename from URL
  static String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = Uri.decodeComponent(uri.path);
      return path.split('/').last;
    } catch (e) {
      return 'download';
    }
  }

// Updated PDF detection
  static Future<bool> _isPdfFile(String url) async {
    try {
      final response = await html.HttpRequest.request(
        url,
        method: 'HEAD',
      );
      final contentType =
          response.responseHeaders['Content-Type']?.toLowerCase();
      return contentType?.contains('application/pdf') ?? false;
    } catch (e) {
      return url.toLowerCase().contains('.pdf');
    }
  }

// Updated content type detection
  static Future<String?> _getContentType(String url) async {
    try {
      final response = await html.HttpRequest.request(
        url,
        method: 'HEAD',
      );
      return response.responseHeaders['Content-Type'];
    } catch (e) {
      return null;
    }
  }

// Keep existing mime type mapping
  static String? _getExtensionFromMimeType(String? mimeType) {
    const mimeMap = {
      'application/pdf': 'pdf',
      'application/msword': 'doc',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          'docx',
      // ... rest of your mime type mappings
    };
    return mimeType != null ? mimeMap[mimeType.split(';').first] : null;
  }
}

Widget textForDataRowInTable({
  required String text,
  maxWidth = 150,
}) {
  return Container(
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
