import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Shift{

  Shift({@required this.name, this.endTime, this.startTime});

  final String name;
  TimeOfDay startTime, endTime;

  set shiftStartTime(TimeOfDay startTime) {
    this.startTime = startTime;
  }

  set shiftEndTime(TimeOfDay endTime) {
    this.endTime = endTime;
  }

  void editShiftStartTime(TimeOfDay time) {
    this.startTime = time;
  }

  void editShiftEndTime(TimeOfDay time) {
    this.endTime = time;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

  toJSON() {
    return {
      'name' : name,
      'startTime' : formatTimeOfDay(startTime),
      'endTime' : formatTimeOfDay(endTime),
    };
  }

}