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
import 'security.dart';

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(options: options)
      : await Firebase.initializeApp();
  globalPrefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DataHub AI',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoadingScreen()),
        GetPage(name: '/loginScreen', page: () => LoginScreen()),
        GetPage(name: '/registerScreen', page: () => const RegisterScreen()),
        GetPage(
            name: '/mainScreen',
            page: () => MainScreen(),
            middlewares: [AuthMiddleware()])
      ],
    );
  }
}
