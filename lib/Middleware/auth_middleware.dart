import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    String? userId = globalPrefs?.getString('userId');

    // Redirect to login screen if user is not logged in
    if (userId == null || userId.isEmpty) {
      return const RouteSettings(name: '/loginScreen');
    }
    return null; // Proceed if logged in
  }
}
