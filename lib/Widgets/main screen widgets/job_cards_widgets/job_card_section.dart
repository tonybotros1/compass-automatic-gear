import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container jobCardSection(context, JobCardController controller) {
  return Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      child: Column(spacing: 10, children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.jobCardCounter.value,
                labelText: 'Job No.',
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.invoiceCounter.value,
                labelText: 'Invoice No.',
              ),
            ),
            Expanded(
              flex: 2,
              child: myTextFormFieldWithBorder(
                controller: controller.lpoCounter.value,
                labelText: 'LPO No.',
              ),
            )
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.jobCardDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.jobCardDate.value,
                labelText: 'Job Date',
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.invoiceDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.invoiceDate.value,
                labelText: 'Invoice Date',
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.approvalDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.approvalDate.value,
                labelText: 'Approval Date',
              ),
            )
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.startDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.startDate.value,
                labelText: 'Start Date',
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.finishDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.finishDate.value,
                labelText: 'Finish Date',
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.deliveryDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.deliveryDate.value,
                labelText: 'Delivery Date',
              ),
            )
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      isnumber: true,
                      controller: controller.jobWarrentyDays.value,
                      labelText: 'Warrenty Days',
                    ),
                  ),
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      isnumber: true,
                      controller: controller.jobWarrentyKM.value,
                      labelText: 'Warrenty KM',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.jobWarrentyEndDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.jobWarrentyEndDate.value,
                labelText: 'Warrenty End Date',
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: myTextFormFieldWithBorder(
                      isnumber: true,
                      controller: controller.minTestKms.value,
                      labelText: 'Min Test KMs',
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      controller: controller.reference1.value,
                      labelText: 'Reference 1',
                    ),
                  ),
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      controller: controller.reference2.value,
                      labelText: 'Reference 2',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: myTextFormFieldWithBorder(
              controller: controller.deliveryTime.value,
              labelText: 'Delivery Time',
              hintText: 'Enter Delivery Time',
            )),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.jobCancelationDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                isDate: true,
                controller: controller.jobCancelationDate.value,
                labelText: 'Cancelation Date',
              ),
            )
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Job Notes',
                controller: controller.jobNotes,
                maxLines: 7,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Delivery Notes',
                controller: controller.deliveryNotes,
                maxLines: 7,
              ),
            )
          ],
        ),
      ]));
}
