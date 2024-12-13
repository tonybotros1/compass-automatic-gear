import 'package:flutter/material.dart';
import 'package:get/get.dart';

var fontStyle = TextStyle(fontSize: 20, color: Colors.grey.shade700);
var fontStyle2 = TextStyle(fontSize: 16, color: Colors.grey.shade700);
var fontStyle3 = const TextStyle(fontSize: 16, color: Colors.white);
// var mainColor = const Color.fromARGB(255, 228, 200, 233);

var mainColor = const Color(0xffEA2027);
// var mainColor = const Color(0xff27374D);
var secColor = const Color(0xffeb4d4b);
// var secColor = const Color(0xff526D82);
var containerColor = const Color(0xffF5F5F5);

// new colors
var mainColorForWeb = const Color(0xFFF4F4F8);

const iconColor = Color(0xFF969BA9);
const menuSelectionColor = Color(0xffEA2027);
const backgroundColor2 = Color(0xFFFFFFFF);

Widget verticalSpace({int space = 20}) {
  return SizedBox(
    height: Get.height / space,
  );
}

