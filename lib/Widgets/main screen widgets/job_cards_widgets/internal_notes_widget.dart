import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';

Future internalNotesDialog(BuildContext context, JobCardController controller,
    BoxConstraints constraints) {
  return Get.dialog(
    Dialog(
        child: Container(
      height: 400,
      width: 600,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            width: double.infinity,
            height: 70,
            child: Row(
              spacing: 20,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                Text(
                  'Internal Notes',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ),
          Expanded(
              child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
                itemCount: controller.internalNotes.length,
                itemBuilder: (context, i) {
                  return Text('data');
                }),
          )),
          Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // child:
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        )),
                  )
                ],
              ))
        ],
      ),
    )),
  );
}
