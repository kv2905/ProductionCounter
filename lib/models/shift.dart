import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

}