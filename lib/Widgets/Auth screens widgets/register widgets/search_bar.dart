import 'package:flutter/material.dart';

import '../../../consts.dart';

Row searchBar({
  required BoxConstraints constraints,
  required context,
  required controller,
  required title,
  required buttonTitle,
   Widget? button,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: constraints.maxWidth / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            // color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  // flex: 1,
                  child: Icon(
                    Icons.search,
                    color: iconColor,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: SizedBox(
                  width: constraints.maxWidth / 2,
                  child: TextFormField(
                    controller: controller.search.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: iconColor),
                      hintText: title,
                    ),
                    style: const TextStyle(color: iconColor),
                  ),
                ),
              ),
              FittedBox(
                child: IconButton(
                  onPressed: () {
                    controller.search.value.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: iconColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      const Expanded(flex: 1, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: button
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
            onPressed: () {
              controller.getAllUsers();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.grey,
            )),
      )
    ],
  );
}
