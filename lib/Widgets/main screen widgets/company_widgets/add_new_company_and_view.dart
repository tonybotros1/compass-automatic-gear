import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../consts.dart';
import 'company_details.dart';
import 'contact_details.dart';
import 'responsibilities_details.dart';

Widget addNewCompanyOrView({
  required CompanyController controller,
  bool? canEdit = true,
}) {
  return ListView(
    children: [
      labelContainer(
          lable: Text(
        'Company Details',
        style: fontStyle1,
      )),
      companyDetails(controller: controller),
      const SizedBox(
        height: 5,
      ),
      labelContainer(
          lable: Text(
        'Contact Details',
        style: fontStyle1,
      )),
      contactDetails(controller: controller),
      const SizedBox(
        height: 5,
      ),
      labelContainer(
          lable: Text(
        'Responsibilities',
        style: fontStyle1,
      )),
      responsibilities(controller: controller)
    ],
  );
}
