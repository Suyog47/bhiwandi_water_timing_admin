import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:water_timing/constants/colors.dart';
import 'package:water_timing/constants/heights.dart';
import 'package:water_timing/constants/size_helpers.dart';
import 'package:water_timing/controllers/data_controller.dart';
import 'package:water_timing/screens/add_update_screen.dart';
import 'package:get/get.dart';
import 'package:water_timing/utils/date_time_function.dart';
import 'package:water_timing/utils/shared_preference_data.dart';
import 'package:water_timing/utils/snackbars.dart';
import 'package:water_timing/widgets/loaders.dart';
import 'package:water_timing/widgets/table_ui.dart';

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
  late List<TableRow> arr = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    setTiming(_dataController.timings);
    areaNotifier = ValueNotifier(_dataController.selectedArea ?? _dataController.areas[0]);
    _newsTextController.text = _dataController.news.value;
    super.initState();
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
                onRefresh: _onRefresh,
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
                                      onChanged: (newValue) => _onChanged(newValue),
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
                            height10,
                            Table(
                              border: TableBorder.all(color: blackColor),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                    decoration: const BoxDecoration(
                                      color: amberColor,
                                    ),
                                    children: [
                                      CustomTableUI()
                                          .headerTableCell(text: 'From'),
                                      CustomTableUI()
                                          .headerTableCell(text: 'Till'),
                                      CustomTableUI()
                                          .headerTableCell(text: 'Actions'),
                                    ]),
                              ],
                            ),
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
                          onTap: _onSaveNews,
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


  void setTiming(dynamic timing) {
    arr.clear();
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
                  CustomTableUI().bodyTableCell(child: Text(
                    e['from'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),),

                  CustomTableUI().bodyTableCell(child: Text(
                    e['till'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),),

                  CustomTableUI().bodyTableCell(child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => _onEditClicked(e['id'], e['from'], e['till']),
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
                            onTap: () => _onDeleteClicked(e['id']),
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
                      ))
                  ),
                ]),
          );
        });
      });
    }
  }

  Future _onRefresh() async {
    await _dataController.getAllData();
    if(_dataController.response == 'success'){
      setTiming(_dataController.timings);
    }
    else{
      CustomSnackBar().alert(
          "Oops...something went wrong, please try again later", context,
          color: redColor);
    }
    _refreshController.refreshCompleted();
  }

  void _onChanged(area) {
    SharedPreferenceData().setData(area!);
    _dataController.selectedArea = area;
    areaNotifier.value = area;
    _dataController.getTimings(area);
    setTiming(_dataController.timings);
    _newsTextController.text = _dataController.news.value;
  }

  void _onEditClicked(id, fromTime, tillTime) {
    final TimeOfDay from = TimeConversion().convertTo24Hr(fromTime);
    final TimeOfDay till = TimeConversion().convertTo24Hr(tillTime);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddUpdateScreen(from: from, till: till, cameFor: 'edit', timingId: id,),
      ),
    );
  }

  Future _onDeleteClicked(id) async {
    await _dataController.deleteTiming(id);
    if (_dataController.response == 'success') {
      await _dataController.getAllData();
      setTiming(_dataController.timings);
      CustomSnackBar()
          .alert("Time has been deleted", context, color: greenColor);
    } else {
      CustomSnackBar().alert(
          "Oops...something went wrong, try to delete it again", context,
          color: redColor);
    }
  }

  Future _onSaveNews() async {
    await _dataController.saveNews(_newsTextController.text);
    if (_dataController.response == 'success') {
      await _dataController.getAllData();
      CustomSnackBar()
          .alert("News has been saved", context, color: greenColor);
    } else {
      CustomSnackBar().alert(
          "Oops...something went wrong, try to delete it again", context,
          color: redColor);
    }
  }

}
