import 'package:flutter/material.dart';
import 'package:water_timing/constants/colors.dart';
import 'package:water_timing/constants/size_helpers.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({Key? key, required this.child,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: displayWidth(context) * 0.36,
      decoration: BoxDecoration(
          border: Border.all(color: greyColor, width: 2.0),
          borderRadius: BorderRadius.circular(5)),
      child: Center(child: child),
    );
  }
}
