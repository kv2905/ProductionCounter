import 'package:flutter/foundation.dart';
import 'package:tenupproductioncounter/models/shift.dart';

class ShiftsData extends ChangeNotifier {
  List<Shift> _shifts = [
    Shift(name: 'Shift 1'),
    Shift(name: 'Shift 2'),
    Shift(name: 'Shift 3'),
  ];

  List<Shift> get shifts {
    return _shifts;
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

}