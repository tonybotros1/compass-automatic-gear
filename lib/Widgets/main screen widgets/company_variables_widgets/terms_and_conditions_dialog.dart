import 'package:datahubai/Controllers/Main%20screen%20controllers/company_variables_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../text_button.dart';

Future<dynamic> termsAndConditionsDialog({
  required CompanyVariablesController controller,
  required TextEditingController termsAndConditions,
  required String screenName,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 800,
          height: 800,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: mainColor,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      '🖋️ $screenName',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<CompanyVariablesController>(
                      builder: (controller) => ClickableHoverText(
                        onTap: onPressed,
                        text: controller.updatingTermsAndConditions.value == false
                            ? 'Save'
                            : '•••',
                      ),
                    ),
                    separator(),
                    closeIcon(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: myTextFormFieldWithBorder(
                  labelText: 'Terms and Conditions',
                  controller: termsAndConditions,
                  maxLines: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
