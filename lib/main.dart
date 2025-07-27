import 'package:datahubai/Middleware/route_middleware.dart';
import 'package:datahubai/Screens/mobile%20Screens/card_images_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Middleware/auth_middleware.dart';
import 'Screens/Auth Screens/loading_screen.dart';
import 'Screens/Auth Screens/login_screen.dart';
import 'Screens/Auth Screens/register_screen.dart';
import 'Screens/Main screens/main_screen.dart';
import 'Screens/mobile Screens/main_screen_fro_mobile.dart';
import 'Widgets/main screen widgets/job_cards_widgets/image_gallery_viewer.dart';
import 'security.dart';
// import 'package:web/web.dart' as web;

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(options: options)
      : await Firebase.initializeApp();
  globalPrefs = await SharedPreferences.getInstance();

  // if (web.window.location.pathname != '/') {
  //   // Replace the current URL with '/'
  //   web.window.history.replaceState(null, 'DataHub AI', '/');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       GetMaterialApp(
        title: 'DataHub AI',
        debugShowCheckedModeBanner: false,
        
        initialRoute: '/',
        getPages: [
          GetPage(name: '/cardImagesScreen', page: () => CardImagesScreen()),
          GetPage(
              name: '/',
              page: () => const LoadingScreen(),
              middlewares: [InitialRedirectMiddleware()]),
          GetPage(name: '/loginScreen', page: () => LoginScreen()),
          GetPage(
            name: '/registerScreen',
            page: () => const RegisterScreen(),
          ),
          GetPage(
              name: '/imageViewer',
              page: () => ImageGalleryViewer(),
              middlewares: [AuthMiddleware(), InitialRedirectMiddleware()]),
          GetPage(
              name: '/mainScreen',
              page: () => MainScreen(),
              middlewares: [AuthMiddleware(), InitialRedirectMiddleware()]),
          GetPage(
              name: '/mainScreenForMobile',
              page: () => MainScreenForMobile(),
              middlewares: [AuthMiddleware()]),
        ],
      );
    
  }
}
