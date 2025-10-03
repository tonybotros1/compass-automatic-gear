import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/menus_controller.dart';
import '../../my_text_field.dart';

Widget addOrEditMenu({required MenusController controller}) {
  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: myTextFormFieldWithBorder(
          labelText: 'Menu Name',
          hintText: 'Enter Menu Name',
          controller: controller.menuName,
          validate: false,
          obscureText: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: myTextFormFieldWithBorder(
          labelText: 'Code',
          hintText: 'Enter Code',
          controller: controller.code,
          validate: false,
          obscureText: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: myTextFormFieldWithBorder(
          labelText: 'Menu Route',
          controller: controller.menuRoute,
          validate: false,
          obscureText: false,
        ),
      ),
    ],
  );
}

// Widget myTextFormField2({
//   required String labelText,
//   required String hintText,
//   required controller,
//   required validate,
//   required obscureText,
//   IconButton? icon,
//   required constraints,
//   keyboardType,
// }) {
//   return TextFormField(
//     obscureText: obscureText,
//     keyboardType: keyboardType,
//     controller: controller,
//     decoration: InputDecoration(
//       suffixIcon: icon,
//       hintStyle: const TextStyle(color: Colors.grey),
//       labelText: labelText,
//       hintText: hintText,
//       labelStyle: TextStyle(color: Colors.grey.shade700),
//       focusedBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey, width: 2.0),
//       ),
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey, width: 1.0),
//       ),
//       errorBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 1.0),
//       ),
//       focusedErrorBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 2.0),
//       ),
//     ),
//     validator: validate != false
//         ? (value) {
//             if (value!.isEmpty) {
//               return 'Please Enter $labelText';
//             }
//             return null;
//           }
//         : null,
//   );
// }
