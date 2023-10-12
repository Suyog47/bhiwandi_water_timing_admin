import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:water_timing/constants/colors.dart';
import 'package:water_timing/constants/heights.dart';
import 'package:water_timing/constants/size_helpers.dart';
import 'package:water_timing/controllers/internet_controller.dart';

class InternetCheck extends StatefulWidget {
  final Widget? child;

  const InternetCheck({this.child, Key? key}) : super(key: key);

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  final InternetController internetController = Get.find();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Obx(() {
          return Scaffold(
          backgroundColor: whiteColor,
          body: (internetController.isInternetActive.value == false)
              ? const ErrorScreen()
              : widget.child);
      },
    ));
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          backgroundColor: whiteColor,
          body: Center(
            child: Container(
              height: 150,
              width: displayWidth(context) * 0.8,
              decoration: BoxDecoration(
                color: themeBlueColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 5,
                    color: greyColor,
                  )
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      color: whiteColor,
                      size: 35,
                    ),
                    height10,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Oops, you are not connected to the internet... Please connect and restart the app",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
