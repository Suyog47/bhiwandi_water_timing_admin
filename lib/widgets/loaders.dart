import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/colors.dart';

class CircularLoader extends StatelessWidget {
  final int load;
  final bool bgContainer;
  final Color color;

  const CircularLoader({
    this.load = 1,
    this.bgContainer = true,
    this.color = themeBlueColor,
  });

  @override
  Widget build(BuildContext context) {
    return (load == 1)
        ? bgContainer
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: blackColor.withOpacity(0.3),
                child: SpinKitCircle(
                  color: color,
                  size: 40.0,
                ),
              )
            : SpinKitCircle(
                color: color,
                size: 40.0,
              )
        : const Text("");
  }
}

class FoldingCubeLoader extends StatelessWidget {
  final int load;
  final bool bgContainer;
  final Color color;

  const FoldingCubeLoader({
    this.load = 1,
    this.bgContainer = true,
    this.color = themeBlueColor,
  });

  @override
  Widget build(BuildContext context) {
    return (load == 1)
        ? bgContainer
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                color: blackColor.withOpacity(0.3),
                child: Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SpinKitFoldingCube(
                      color: color,
                      size: 40.0,
                    ),
                  ),
                ),
              )
            : SpinKitFoldingCube(
                color: color,
                size: 40.0,
              )
        : const Text("");
  }
}
