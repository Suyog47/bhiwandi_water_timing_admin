import 'package:BWT_admin/constants/colors.dart';
import 'package:BWT_admin/constants/heights.dart';
import 'package:BWT_admin/constants/size_helpers.dart';
import 'package:BWT_admin/controllers/data_controller.dart';
import 'package:BWT_admin/utils/date_time_function.dart';
import 'package:BWT_admin/utils/navigations.dart';
import 'package:BWT_admin/utils/snackbars.dart';
import 'package:BWT_admin/widgets/custom_container.dart';
import 'package:BWT_admin/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddUpdateScreen extends StatefulWidget {
  final String cameFor;
  final TimeOfDay from;
  final TimeOfDay till;
  final String timingId;

  const AddUpdateScreen(
      {this.timingId = '0',
      required this.cameFor,
      required this.from,
      required this.till,
      Key? key})
      : super(key: key);

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final DataController _dataController = Get.find();
  late ValueNotifier<TimeOfDay> startTimeNotifier;
  late ValueNotifier<TimeOfDay> endTimeNotifier;

  @override
  void initState() {
    startTimeNotifier = ValueNotifier(widget.from);
    endTimeNotifier = ValueNotifier(widget.till);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text(
            "Add Timings",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: whiteColor),
          ),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: displayHeight(context) * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Estimated from:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            height10,
                            InkWell(
                              onTap: () async {
                                startTimeNotifier.value = (await showTimePicker(
                                        context: context,
                                        initialTime: startTimeNotifier.value)) ??
                                    startTimeNotifier.value;
                              },
                              child: ValueListenableBuilder<TimeOfDay>(
                                  valueListenable: startTimeNotifier,
                                  builder: (_, start, __) {
                                  return CustomContainer(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 5),
                                          child: Center(
                                            child: Text(
                                              start.format(context),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 27),
                                            ),
                                          )));
                                }
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          " - ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 50),
                        ),
                        Column(
                          children: [
                            const Text(
                              "Estimated till:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            height10,
                            InkWell(
                              onTap: () async {
                                endTimeNotifier.value = (await showTimePicker(
                                    context: context, initialTime: endTimeNotifier.value)) ??
                                    endTimeNotifier.value;
                              },
                              child: ValueListenableBuilder<TimeOfDay>(
                                  valueListenable: endTimeNotifier,
                                  builder: (_, end, __) {
                                  return CustomContainer(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 5),
                                          child: Center(
                                            child: Text(
                                              end.format(context),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 27),
                                            ),
                                          )));
                                }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    height60,
                    InkWell(
                      onTap: _onSaveTime,
                      child: Container(
                        height: 50,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                            color: themeBlueColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              return FoldingCubeLoader(
                load: _dataController.load.value,
              );
            })
          ],
        ),
      ),
    );
  }

  Future _addTime() async {
    await _dataController.addTiming(
        startTimeNotifier.value.format(context), endTimeNotifier.value.format(context));
    if (_dataController.response == 'success') {
      await _dataController.getAllData();
      CustomSnackBar().alert("Timing for this area has been added", context,
          color: greenColor);
    } else {
      CustomSnackBar().alert(
          "Oops...something went wrong, Try to add ot again", context,
          color: redColor);
    }
  }

  Future _editTime() async {
    await _dataController.editTiming(
        widget.timingId, startTimeNotifier.value.format(context), endTimeNotifier.value.format(context));
    if (_dataController.response == 'success') {
      await _dataController.getAllData();
      CustomSnackBar()
          .alert("Time has been edited", context, color: greenColor);
    } else {
      CustomSnackBar().alert(
          "Oops...something went wrong, Try to edit again", context,
          color: redColor);
    }
  }

  Future _onSaveTime() async {
    bool isTrue = TimeComparison()
        .isTime1BeforeTime2(startTimeNotifier.value, endTimeNotifier.value);

    if (isTrue) {
      if (widget.cameFor == "add") {
        await _addTime();
      } else {
        await _editTime();
      }
      Navigate().toDashboard();
    } else {
      CustomSnackBar().alert(
          "Start time cannot be later than or equal to End time",
          context,
          color: redColor);
    }
  }
}
