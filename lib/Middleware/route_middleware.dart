import 'package:get/get.dart';

import '../Screens/Auth Screens/loading_screen.dart';

class InitialRedirectMiddleware extends GetMiddleware {
  static bool isInitialLoad = true;

  @override
  GetPage? onPageCalled(GetPage? page) {
    if (isInitialLoad && page?.name != '/') {
      isInitialLoad = false;
      return GetPage(name: '/', page: () => const LoadingScreen());
    }
    isInitialLoad = false;
    return page;
  }
}