import 'package:flutter/material.dart';
import '../Auth screens widgets/register widgets/my_text_form_field.dart';

Widget addNewScreenOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required controller,
  TextEditingController? screenName,
  TextEditingController? route,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: screenName ?? controller.screenName,
          labelText: 'Screen Name',
          hintText: 'Enter Screen name',
          keyboardType: TextInputType.name,
          validate: true,
        ),
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: route ?? controller.route,
          labelText: 'Route',
          hintText: 'Enter route name',
          keyboardType: TextInputType.emailAddress,
          validate: true,
        ),
       
      ],
    ),
  );
}
