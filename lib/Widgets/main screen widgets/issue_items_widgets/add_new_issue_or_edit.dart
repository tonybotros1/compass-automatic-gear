import 'package:datahubai/Controllers/Main%20screen%20controllers/issue_items_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';

Widget addNewIssueOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required IssueItemsController controller,
  bool? canEdit,
  required String id,
}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  labelContainer(lable: Text('Main Infos', style: fontStyle1)),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: containerDecor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Number',
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Date',
                                  ),
                                ],
                              ),
                              CustomDropdown(
                                hintText: 'Branch',
                                showedSelectedName: 'name',
                                width: 310,
                                items: {},
                              ),
                              CustomDropdown(
                                hintText: 'Issue Types',
                                showedSelectedName: 'name',
                                width: 150,
                                items: {},
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  myTextFormFieldWithBorder(
                                    labelText: 'Job / Converter',
                                    width: 310,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                              CustomDropdown(
                                hintText: 'Received By',
                                showedSelectedName: 'name',
                                width: 310,
                                items: {},
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: myTextFormFieldWithBorder(
                            labelText: 'Note',
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        labelContainer(
          lable: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items', style: fontStyle1),
              // newItemButton(context, constraints, controller, id),
            ],
          ),
        ),
        // itemsSection(context: context, constraints: constraints, id: id),
      ],
    ),
  );
}
