import 'dart:io';
import 'package:BWT_admin/screens/splash_screen.dart';
import 'package:BWT_admin/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: Routes().createRoutes(),
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
    );
  }
}