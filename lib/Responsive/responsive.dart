import 'package:flutter/material.dart';

class ScreenSize extends StatelessWidget {
  const ScreenSize(
      {super.key,
      required this.web,
      required this.tablet,
      required this.mobile,
      required this.bigMobile});

  final Widget web;
  final Widget tablet;
  final Widget bigMobile;
  final Widget mobile;

  // Static method to determine if it's a web screen
  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 1024;
  }

  static bool isBigMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 700;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 500;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 1024) {
      return web;
    } else if (size.width < 1024) {
      return tablet;
    } else if (size.width <= 700) {
      return bigMobile;
    } else {
      return mobile;
    }
  }
}
