import 'package:flutter/material.dart';
import '../Auth screens widgets/register widgets/my_text_form_field.dart';

Widget addNewMenuOrView({
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
        // Expanded(
        //   child: Container(
        //       decoration: BoxDecoration(
        //           border: Border.all(color: Colors.grey),
        //           borderRadius: BorderRadius.circular(15)),
        //       child: Obx(
        //         () => controller.isLoading.value == false
        //             ? ListView.builder(
        //                 itemCount: controller.selectedRoles.length,
        //                 shrinkWrap: true,
        //                 itemBuilder: (context, i) {
        //                   return ListTile(
        //                       leading: Obx(
        //                         () => Checkbox(
        //                             activeColor: Colors.blue,
        //                             value: controller.selectedRoles.values
        //                                 .elementAt(i)[1],
        //                             onChanged: (selected) {
        //                               var key = controller
        //                                   .selectedRoles.keys
        //                                   .elementAt(i); // Get the key
        //                               controller.selectedRoles[key] = [
        //                                 controller.selectedRoles[key]![0],
        //                                 selected!,
        //                               ];
        //                             }),
        //                       ),
        //                       title: Text(
        //                           '${controller.selectedRoles.keys.elementAt(i)}'));
        //                 })
        //             : CircularProgressIndicator(
        //                 color: mainColor,
        //               ),
        //       )),
        // ),
      ],
    ),
  );
}
