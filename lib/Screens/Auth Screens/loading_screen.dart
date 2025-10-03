import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Auth screen controllers/loading_screen_controller.dart';
import '../../consts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadingScreenController>(
      init: LoadingScreenController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: controller.needRefresh.isFalse
                ? Center(child: loadingProcess)
                : ElevatedButton(
                    onPressed: () {
                      controller.needRefresh.value = false;
                      controller.checkLogStatus();
                    },
                    child: const Text('Refresh'),
                  ),
          ),
        );
      },
    );
  }
}
