import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:water_timing/constants/colors.dart';
import 'package:water_timing/constants/heights.dart';
import 'package:water_timing/constants/size_helpers.dart';
import 'package:water_timing/controllers/data_controller.dart';
import 'package:water_timing/screens/add_update_screen.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:water_timing/utils/shared_preference_data.dart';
import 'package:water_timing/utils/snackbars.dart';
import 'package:water_timing/widgets/loaders.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final TextEditingController _newsTextController =
      TextEditingController();
  late ValueNotifier<String> areaNotifier;
  final DataController _dataController = Get.find();
  late List<TableRow> header = [];
  late List<TableRow> arr = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    setTableHeader();
    setTimings(_dataController.timings);
    areaNotifier = ValueNotifier(_dataController.selectedArea ?? _dataController.areas[0]);
    _newsTextController.text = _dataController.news.value;
    super.initState();
  }

  void setTableHeader() {
    header = [
      const TableRow(
          decoration: BoxDecoration(
            color: lightGreyColor,
          ),
          children: [
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "From",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "Till",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "Actions",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ))
          ]),
    ];
  }

  void setTimings(List timing) {
    if(timing[0]['id'] == null){
      setState(() {
        arr = [];
      });
    }
    else {
      setState(() {
      timing.forEach((e) {
        arr.add(
          TableRow(
              decoration: const BoxDecoration(
                color: lightGreyColor,
              ),
              children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          e['from'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    )),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          e['till'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    )),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 2.0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              final inputFormat = DateFormat("h:mm a");
                              final outputFormat = DateFormat("HH:mm");

                              final fromTime = inputFormat.parse(e['from']!);
                              final tillTime = inputFormat.parse(e['till']!);

                              final TimeOfDay from = TimeOfDay(
                                hour: int.parse((outputFormat.format(fromTime))
                                    .split(":")[0]),
                                minute: int.parse(
                                    (outputFormat.format(fromTime))
                                        .split(":")[1]),
                              );

                              final TimeOfDay till = TimeOfDay(
                                  hour: int.parse(
                                      (outputFormat.format(tillTime))
                                          .split(":")[0]),
                                  minute: int.parse(
                                      (outputFormat.format(tillTime))
                                          .split(":")[1]));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddUpdateScreen(from: from, till: till, cameFor: 'edit', timingId: e['id'],),
                                ),
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: greenColor),
                              child: const Center(
                                child: Icon(
                                  Icons.edit,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              _dataController.load.value = 1;
                              await _dataController.deleteTiming(e['id']);
                              if (_dataController.response == 'success') {
                                await _dataController.getAllData();
                                arr.clear();
                                setTimings(_dataController.timings);
                                CustomSnackBar()
                                    .alert("Time has been deleted", context, color: greenColor);
                              } else {
                                CustomSnackBar().alert(
                                    "Oops...something went wrong, try to delete it again", context,
                                    color: redColor);
                              }
                              _dataController.load.value = 0;
                            },
                            child: Container(
                              height: 35,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: redColor),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                    ))
              ]),
        );
      });
    });
    }
  }

  Future onRefresh() async {
    _dataController.load.value = 1;
    await _dataController.getAllData();
    if(_dataController.response == 'success'){
      arr.clear();
      setTimings(_dataController.timings);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oops...something went wrong, please try again later'),
        ),
      );
    }
    _dataController.load.value = 0;
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: const Text(
              "Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: whiteColor),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUpdateScreen(
                          from: TimeOfDay.now(),
                          till: TimeOfDay.now(),
                          cameFor: 'add',
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_circle,
                    color: whiteColor,
                    size: 35,
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              SmartRefresher(
                enablePullDown: true,
                header: const WaterDropMaterialHeader(),
                controller: _refreshController,
                onRefresh: onRefresh,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 25.0, bottom: 5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Select an area",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            height10,
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey, width: 2)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: ValueListenableBuilder<String>(
                                  valueListenable: areaNotifier,
                                  builder: (_, area, __) {
                                    return DropdownButton<String>(
                                      value: area,
                                      borderRadius: BorderRadius.circular(10),
                                      onChanged: (newValue) async {
                                        SharedPreferenceData().setData(newValue!);
                                        _dataController.selectedArea = newValue;
                                        areaNotifier.value = newValue;
                                        _dataController.getTimings(newValue);
                                        setState(() {
                                          arr.clear();
                                          if (_dataController.timings[0]['from'] !=
                                              null) {
                                            setTimings(_dataController.timings);
                                          }
                                        });
                                        _newsTextController.text = _dataController.news.value;
                                      },
                                      items: _dataController.areas.map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        height30,
                        (arr.isNotEmpty) ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Estimated Timings set for this area",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            height10,
                            height5,
                            Table(
                              border: TableBorder.all(color: blackColor),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: arr,
                            ),
                          ],
                        ) : const Text(
                          "No timings are set for this area",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        height30,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "News:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            height10,
                            height5,
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(color: greyColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: TextField(
                                  minLines: 8,
                                  maxLines: 10,
                                  controller: _newsTextController,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        height30,
                        InkWell(
                          onTap: () async {
                            _dataController.load.value = 1;
                            await _dataController.saveNews(_newsTextController.text);
                            await _dataController.getAllData();
                            _dataController.load.value = 0;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('News has been saved'),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                                color: themeBlueColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                "Add News",
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
              ),
              Obx(() {
                return FoldingCubeLoader(
                  load: _dataController.load.value,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
