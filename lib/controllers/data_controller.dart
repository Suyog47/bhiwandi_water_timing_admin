import 'dart:convert';
import 'package:get/get.dart';
import 'package:water_timing/api_calls/data_api.dart';
import 'package:intl/intl.dart';

class DataController {
  RxInt load = 0.obs;
  String response = "";
  final data = List.empty(growable: true);
  final areas = List.empty(growable: true);
  final timings = List.empty(growable: true);
  String currentAreaId = '';
  dynamic selectedArea;
  RxString news = "".obs;

  Future getData(String id) async {
    try {
      await DataApiCalls().getData(id).then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  Future addTiming(String from, String till) async {
    try {
      await DataApiCalls()
          .addTiming(currentAreaId, from, till)
          .then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  Future editTiming(String id, String from, String till) async {
    try {
      await DataApiCalls()
          .editTiming(id, from, till)
          .then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  Future deleteTiming(String id) async {
    try {
      await DataApiCalls()
          .deleteTiming(id)
          .then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  Future saveNews(String news) async {
    try {
      await DataApiCalls()
           .saveNews(currentAreaId, news)
          .then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  Future getAllData() async {
    data.clear();
    try {
      await DataApiCalls().getAllData().then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            data.addAll(res['data']);
            getAreas(res['data']);
            response = "success";
          } else {
            response = "failure";
          }
        } else {
          response = "failure";
        }
      });
    } finally {}
  }

  void getAreas(List dt) {
    areas.clear();
    for (var e in dt) {
      if (!areas.contains(e['name'])) {
        areas.add(e["name"]);
      }
    }
    getTimings(selectedArea ?? areas[0]);
  }

  void getTimings(String area) {
    timings.clear();
    for (var e in data) {
      if (e['name'] == area) {
        currentAreaId = e['id'];
        timings.add({'id': e['timingId'], 'from': e['fromTime'], 'till': e['tillTime']});
      }
    }
    getNews(area);
  }

  void getNews(String area) {
    news.value = "";
    for (var e in data) {
      if (e['name'] == area) {
        news.value = e["news"] ?? '';
        break;
      }
    }
  }
}
