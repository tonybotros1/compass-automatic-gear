import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoButton filterButton({
  required String title,
  required void Function()? onPressed,
  required bool isSelected,
  bool? isStatus = false,
}) {
  return CupertinoButton(
    sizeStyle: CupertinoButtonSize.small,
    borderRadius: BorderRadius.circular(5),
    color: isSelected == true
        ? isStatus == true
              ? Colors.blueGrey
              : Colors.blue
        : isStatus == true
        ? Colors.blueGrey.shade50
        : Colors.blue.shade50,
    onPressed: onPressed,
    child: Text(
      title,
      style: TextStyle(
        color: isSelected == true
            ? Colors.white
            : isStatus == true
            ? Colors.blueGrey
            : Colors.blue,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

// CupertinoButton findButton({
//   required Widget title,
//   required void Function()? onPressed,
// }) {
//   return CupertinoButton(
//     sizeStyle: CupertinoButtonSize.small,
//     borderRadius: BorderRadius.circular(5),
//     color: Colors.green,
//     onPressed: onPressed,
//     child: Text(
//       title,
//       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//     ),
//   );
// }
