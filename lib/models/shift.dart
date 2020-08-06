import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Shift{

  Shift({@required this.name, this.endTime, this.startTime, this.target});

  final String name;
  TimeOfDay startTime, endTime;
  int target;

  set shiftStartTime(TimeOfDay startTime) {
    this.startTime = startTime;
  }

  set shiftEndTime(TimeOfDay endTime) {
    this.endTime = endTime;
  }

  set shiftTarget(int target) {
    this.target = target;
  }

}