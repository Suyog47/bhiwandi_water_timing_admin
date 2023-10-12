import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConversion{

  TimeOfDay convertTo24Hr(tm){
    final inputFormat = DateFormat("h:mm a");
    final outputFormat = DateFormat("HH:mm");

    final parsedTime = inputFormat.parse(tm);

    TimeOfDay time =  TimeOfDay(
      hour: int.parse((outputFormat.format(parsedTime))
          .split(":")[0]),
      minute: int.parse(
          (outputFormat.format(parsedTime))
              .split(":")[1]),
    );

    return time;
  }
}

class TimeComparison{
  bool isTime1BeforeTime2(startTime, endTime) {
    TimeOfDay time1 = TimeOfDay(
        hour: startTime.hour, minute: startTime.minute);
    TimeOfDay time2 = TimeOfDay(
        hour: endTime.hour, minute: endTime.minute);

    int dayToMinutes1 = time1.hour * 60 + time1.minute;
    int dayToMinutes2 = time2.hour * 60 + time2.minute;

    bool isTime1BeforeTime2 = dayToMinutes1 < dayToMinutes2;

    return isTime1BeforeTime2;
  }

}

