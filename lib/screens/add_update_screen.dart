import 'package:flutter/material.dart';
import 'package:water_timing/constants/colors.dart';
import 'package:water_timing/constants/heights.dart';
import 'package:water_timing/constants/size_helpers.dart';
import 'package:water_timing/controllers/data_controller.dart';
import 'package:water_timing/screens/dashboard.dart';
import 'package:water_timing/utils/snackbars.dart';
import 'package:water_timing/widgets/custom_container.dart';
import 'package:get/get.dart';
import 'package:water_timing/widgets/loaders.dart';

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
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  @override
  void initState() {
    startTime = widget.from;
    endTime = widget.till;
    super.initState();
  }

  int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  bool isTimeOfDayBefore(TimeOfDay time1, TimeOfDay time2) {
    return timeOfDayToMinutes(time1) < timeOfDayToMinutes(time2);
  }

  Future add() async {
    await _dataController.addTiming(
        startTime.format(context), endTime.format(context));
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

  Future edit() async {
    await _dataController.editTiming(
        widget.timingId, startTime.format(context), endTime.format(context));
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
                                startTime = (await showTimePicker(
                                        context: context,
                                        initialTime: startTime)) ??
                                    startTime;
                                setState(() {
                                  startTime = startTime;
                                });
                              },
                              child: CustomContainer(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 5),
                                      child: Center(
                                        child: Text(
                                          startTime.format(context),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                        const Text(
                          " - ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 50),
                        ),
                        InkWell(
                          onTap: () async {
                            endTime = (await showTimePicker(
                                    context: context, initialTime: endTime)) ??
                                endTime;
                            setState(() {
                              endTime = endTime;
                            });
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Estimated till:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              height10,
                              CustomContainer(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 5),
                                      child: Center(
                                        child: Text(
                                          endTime.format(context),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    height60,
                    InkWell(
                      onTap: () async {
                        TimeOfDay time1 = TimeOfDay(
                            hour: startTime.hour, minute: startTime.minute);
                        TimeOfDay time2 = TimeOfDay(
                            hour: endTime.hour, minute: endTime.minute);

                        bool isTime1BeforeTime2 =
                            isTimeOfDayBefore(time1, time2);

                        if (isTime1BeforeTime2) {
                          _dataController.load.value = 1;
                          if (widget.cameFor == "add") {
                            await add();
                          } else {
                            await edit();
                          }
                          _dataController.load.value = 0;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard()),
                              (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Start time cannot be later than or equal to End time'),
                            ),
                          );
                        }
                      },
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
}
