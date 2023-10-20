import 'package:BWT_admin/screens/add_update_screen.dart';
import 'package:BWT_admin/screens/dashboard.dart';
import 'package:BWT_admin/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  Map<String, Widget Function(BuildContext context)> createRoutes() {
    return {
      '/splash': (BuildContext context) => const SplashScreen(),
      '/dashboard': (BuildContext context) => const Dashboard(),
      '/addUpdate': (BuildContext context) {
        dynamic args = ModalRoute.of(context)!.settings.arguments;
        return AddUpdateScreen(
          cameFor: args["cameFor"],
          from: args["from"],
          till: args["till"],
          timingId: args['timingId'] ?? '0',
        );
      }
    };
  }
}
