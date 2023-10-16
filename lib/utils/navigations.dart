import 'package:BWT_admin/screens/add_update_screen.dart';
import 'package:BWT_admin/screens/dashboard.dart';
import 'package:BWT_admin/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Navigate {
  void toSplash(BuildContext context, [Map? data]) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ));
  }

  void toDashboard(BuildContext context, [Map? data]) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
        (route) => false);
  }

  void toAddUpdate(BuildContext context, [Map? data]) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddUpdateScreen(
            cameFor: data!["cameFor"],
            from: data["from"],
            till: data["till"],
            timingId: data['timingId'] ?? '0',
          ),
        ));
  }
}
