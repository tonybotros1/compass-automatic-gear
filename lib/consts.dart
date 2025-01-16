import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

var cancelButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
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
var hideButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff4C585B),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  minimumSize: const Size(100, 40),
);

var unHideButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xffA5BFCC),
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
  backgroundColor: Colors.red,
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

var fontStyle3 = const TextStyle(fontSize: 16, color: Colors.white);
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