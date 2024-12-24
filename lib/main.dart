import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/Auth Screens/loading_screen.dart';
import 'Screens/Auth Screens/login_screen.dart';
import 'Screens/Main screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBkdkjdZyEn4_d436x4Jq_G_39jVynXX1k",
              authDomain: "compass-automatic-gear.firebaseapp.com",
              projectId: "compass-automatic-gear",
              storageBucket: "compass-automatic-gear.firebasestorage.app",
              messagingSenderId: "660504023083",
              appId: "1:660504023083:web:becd167feb642c230b9a6e"))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>  const LoadingScreen()),
        GetPage(name: '/loginScreen', page: () => LoginScreen()),
        GetPage(name: '/mainScreen', page: () =>  MainScreen())
      ],
    );
  }
}
