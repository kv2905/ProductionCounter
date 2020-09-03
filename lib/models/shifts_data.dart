import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/models/shift.dart';

class ShiftsData extends ChangeNotifier {
  List<Shift> _shifts = [];

  List<Shift> get shifts {
    return _shifts;
  }

  void printShiftsData() {
    for(Shift shift in _shifts) {
      print(shift.name);
      print(shift.endTime);
      print(shift.startTime);
    }
  }

  int get shiftCount {
    return _shifts.length;
  }

  List<String> get shiftNames {
    List<String> names = [];
    for(int i=0; i<shiftCount; i++) {
      names.add(_shifts[i].name);
    }
    return names;
  }

  void add(Shift shift) {
    _shifts.add(shift);
    notifyListeners();
  }

  void del(int index) {
    _shifts.removeAt(index);
    notifyListeners();
  }

  void clearShifts() {
    _shifts.clear();
    notifyListeners();
  }

  void editShiftStartTime(int index, TimeOfDay time) {
    _shifts[index].editShiftStartTime(time);
    notifyListeners();
  }

  void editShiftEndTime(int index, TimeOfDay time) {
    _shifts[index].editShiftEndTime(time);
    notifyListeners();
  }

}