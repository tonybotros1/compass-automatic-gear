import 'package:datahubai/Middleware/route_middleware.dart';
import 'package:datahubai/Screens/mobile%20Screens/card_images_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/Main screen controllers/websocket_controller.dart';
import 'Middleware/auth_middleware.dart';
import 'Screens/Auth Screens/loading_screen.dart';
import 'Screens/Auth Screens/login_screen.dart';
import 'Screens/Auth Screens/register_screen.dart';
import 'Screens/Main screens/main_screen.dart';
import 'Screens/mobile Screens/main_screen_fro_mobile.dart';
import 'Widgets/main screen widgets/job_cards_widgets/image_gallery_viewer.dart';
import 'consts.dart';
import 'security.dart';
// import 'package:web/web.dart' as web;

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(options: options)
      : await Firebase.initializeApp();
  globalPrefs = await SharedPreferences.getInstance();

  final ws = Get.put(WebSocketService());
  ws.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DataHub AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStatePropertyAll(coolColor),
          dividerThickness: 0.3,
          headingTextStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          // 5. **Default Text Style for Data**
          dataTextStyle: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        cardTheme: const CardThemeData(color: Colors.white),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xffF6F9FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          elevation: 10,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/cardImagesScreen', page: () => CardImagesScreen()),
        GetPage(
          name: '/',
          page: () => const LoadingScreen(),
          middlewares: [InitialRedirectMiddleware()],
        ),
        GetPage(name: '/loginScreen', page: () => LoginScreen()),
        GetPage(name: '/registerScreen', page: () => const RegisterScreen()),
        GetPage(
          name: '/imageViewer',
          page: () => ImageGalleryViewer(),
          middlewares: [AuthMiddleware(), InitialRedirectMiddleware()],
        ),
        GetPage(
          name: '/mainScreen',
          page: () => MainScreen(),
          middlewares: [AuthMiddleware(), InitialRedirectMiddleware()],
        ),
        GetPage(
          name: '/mainScreenForMobile',
          page: () => MainScreenForMobile(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
