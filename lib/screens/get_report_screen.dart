import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/models/shift.dart';
import 'package:tenupproductioncounter/screens/dashboard.dart';
import 'package:tenupproductioncounter/screens/report_preview_screen.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:tenupproductioncounter/widgets/date_input_field.dart';

class GetReportScreen extends StatefulWidget {
  static const String id = 'get_report_screen';
  @override
  _GetReportScreenState createState() => _GetReportScreenState();
}

class _GetReportScreenState extends State<GetReportScreen> {
  String line,
      shiftName = 'All',
      from = 'from',
      to = 'to',
      startTime,
      endTime,
      interval;
  List<String> lines = ['All'];
  List<String> shiftNames = ['All'];
  List<String> modes = [
    'At interval of 1 minute',
    'At interval of 5 minute',
    'At interval of 10 minute',
    'At interval of 30 minute',
    'At interval of 60 minute',
    'At interval of 120 minute',
    'None'
  ];
  int mode = 0;
  String modeName = 'None', startCount, endCount, maxCount;
  List<Shift> shifts;
  Shift shift;
  DateTime _fromDate, _toDate;
  bool isLoading;
  final dbRef = FirebaseDatabase.instance.reference().child('Company1');

  List<List<String>> _report = [];

  _getLines() async {
    int i = 1;
    await dbRef.once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, values) {
        setState(() {
          lines.add('line$i');
          i++;
        });
      });
    });
    await _getShifts(line);
    setState(() {
      isLoading = false;
    });
  }

  _getShifts(String line) async {
    setState(() {
      shiftNames = ['All'];
      shifts = [];
    });
    if (line == 'All') {
      return;
    }
    await dbRef.child(line).child('shifts').once().then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, value) {
        Shift s = Shift(name: value['name']);
        s.startTime = stringToTimeOfDay(value['startTime']);
        s.endTime = stringToTimeOfDay(value['endTime']);
        setState(() {
          shiftNames.add(value['name']);
          shifts.add(s);
        });
      });
    });
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  @override
  void initState() {
    isLoading = true;
    line = 'line1';
    shift = null;
    _getLines();
    super.initState();
  }

  Future<List<List<String>>> getOfflineReport() async {
    List<List<String>> temp = [];
    List<String> offlineEncoded = [];
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;

    await dbRef.child('line1').child('offline').once().then((DataSnapshot s) {
      Map<dynamic, dynamic> files = s.value;
      files.forEach((key, value) {
        offlineEncoded.add(value.split(',')[2]);
      });
    });

    for (String element in offlineEncoded) {
      final offlineDecoded = base64Decode(element);
      var file = File('$documentPath/offline_report.txt');
      file.writeAsBytesSync(offlineDecoded);
      await file.readAsString().then((value) {
        List<String> data = value.split('\n');
        data.forEach((entry) {
          List<String> entries = entry.split(',');
          if (entries.length == 4) {
            String countString = entries[1];
            String timeString = entries[2];
            String dateString = entries[3];
            DateTime date = DateTime.parse(dateString);
            if ((date.isAfter(_fromDate) || date.isAtSameMomentAs(_fromDate)) &&
                (date.isBefore(_toDate) || date.isAtSameMomentAs(_toDate))) {
              if (shift == null && int.parse(countString) >= 0) {
                temp.add([dateString, timeString, countString]);
              } else {
                TimeOfDay time = TimeOfDay(
                    hour: int.parse(timeString.split(":")[0]),
                    minute: int.parse(timeString.split(":")[1]));
                int t1 = shift.startTime.hour * 60 + shift.startTime.minute;
                int t = time.hour * 60 + time.minute;
                int t2 = shift.endTime.hour * 60 + shift.endTime.minute;
                if (t1 <= t && t <= t2 && int.parse(countString) >= 0) {
                  temp.add([dateString, timeString, countString]);
                }
              }
            }
          }
        });
      });
    }

    print(temp);
    return temp;
  }

  Future<List<List<String>>> getReport() async {
    List<List<String>> temp = [];

    if (line != 'All') {
      await dbRef.child(line).child('data').once().then((DataSnapshot snap) {
        Map<dynamic, dynamic> days = snap.value;
        days.values.forEach((element) {
          Map<dynamic, dynamic> entries = element;
          entries.forEach((key, value) {
            if (value['date'] != null &&
                value['time'] != null &&
                value['count'] != null) {
              DateTime date = DateTime.parse(value['date']);
              if ((date.isAfter(_fromDate) ||
                      date.isAtSameMomentAs(_fromDate)) &&
                  (date.isBefore(_toDate) || date.isAtSameMomentAs(_toDate))) {
                if (shift == null) {
                  temp.add([
                    value['date'],
                    value['time'],
                    value['count'].toString()
                  ]);
                } else {
                  TimeOfDay time = TimeOfDay(
                      hour: int.parse(value['time'].split(":")[0]),
                      minute: int.parse(value['time'].split(":")[1]));
                  int t1 = shift.startTime.hour * 60 + shift.startTime.minute;
                  int t = time.hour * 60 + time.minute;
                  int t2 = shift.endTime.hour * 60 + shift.endTime.minute;
                  if (t1 <= t && t <= t2) {
                    temp.add([
                      value['date'],
                      value['time'],
                      value['count'].toString()
                    ]);
                  }
                }
              }
            }
          });
        });
      });
    } else {
      for (int i = 1; i < lines.length; i++) {
        await dbRef
            .child('line$i')
            .child('data')
            .once()
            .then((DataSnapshot snap) {
          Map<dynamic, dynamic> days = snap.value;
          days.values.forEach((element) {
            Map<dynamic, dynamic> entries = element;
            entries.forEach((key, value) {
              if (value['date'] != null &&
                  value['time'] != null &&
                  value['count'] != null) {
                DateTime date = DateTime.parse(value['date']);
                if (date.isAfter(_fromDate) && date.isBefore(_toDate)) {
                  if (shift == null) {
                    temp.add([
                      value['date'],
                      value['time'],
                      value['count'].toString()
                    ]);
                  } else {
                    TimeOfDay time = TimeOfDay(
                        hour: int.parse(value['time'].split(":")[0]),
                        minute: int.parse(value['time'].split(":")[1]));
                    double t1 =
                        (shift.startTime.hour + shift.startTime.minute) / 60.0;
                    double t = (time.hour + time.minute) / 60.0;
                    double t2 =
                        (shift.endTime.hour + shift.endTime.minute) / 60.0;

                    if (t1 <= t && t <= t2) {
                      temp.add([
                        value['date'],
                        value['time'],
                        value['count'].toString()
                      ]);
                    }
                  }
                }
              }
            });
          });
        });
      }
    }
    return temp;
  }

  _alertUser(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _generateReport() async {
    List<List<String>> temp = await getReport();
    List<List<String>> offlineReport = await getOfflineReport();
    temp.addAll(offlineReport);

    //sort temp to get sorted report
    if (temp.length > 0) {
      temp.sort((e1, e2) {
        DateTime d1 = DateTime.parse(e1[0]);
        DateTime d2 = DateTime.parse(e2[0]);
        var r = d1.compareTo(d2);
        if (r != 0) return r;
        var l1 = e1[1].split(':');
        var l2 = e2[1].split(':');
        int t1 = int.parse(l1[0]) * 60 * 60 +
            int.parse(l1[1]) * 60 +
            int.parse(l1[2]);
        int t2 = int.parse(l2[0]) * 60 * 60 +
            int.parse(l2[1]) * 60 +
            int.parse(l2[2]);
        return t1.compareTo(t2);
      });
    }

    //generate final report as per time interval
    List<List<String>> finalReport = [];
    int initSecs = 0;
    Set<int> timeSet = Set();
//    if(temp.length == 0) {
//      initSecs = 0;
//    } else {
//      int h = int.parse(temp[0][1].split(':')[0]);
//      int m = int.parse(temp[0][1].split(':')[0]);
//      int s = int.parse(temp[0][1].split(':')[0]);
//      initSecs = (h*60*60) + (m*60) + 60;
//    }
//    if(temp.length > 0) {
//      finalReport.add(temp[0]);
//    }
    switch (mode) {
      case 0:
        {
          finalReport = temp;
        }
        break;
      case 1:
        {
          int d = 60;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
      case 2:
        {
          int d = 300;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
      case 3:
        {
          int d = 600;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
      case 4:
        {
          int d = 1800;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
      case 5:
        {
          int d = 3600;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
      case 6:
        {
          int d = 7200;
          for (List<String> entry in temp) {
            int h = int.parse(entry[1].split(':')[0]);
            int m = int.parse(entry[1].split(':')[1]);
            int secs = (h * 60 * 60) + (m * 60);
            if ((secs - initSecs) % d == 0 && (secs - initSecs) / d >= 0) {
              if(!timeSet.contains(secs)) {
                finalReport.add(entry);
                timeSet.add(secs);
              }
            }
          }
        }
        break;
    }
    setState(() {
      startCount = finalReport.isEmpty ? '0' : finalReport[0][2];
      endCount = finalReport.isEmpty ? '0' : finalReport[finalReport.length - 1][2];
      maxCount = finalReport.isEmpty ? '0' : findMaxCount(finalReport).toString();
      startTime = finalReport.isEmpty ? '00:00' : finalReport[0][1];
      endTime = finalReport.isEmpty ? '00:00' : finalReport[finalReport.length - 1][1];
      interval = modeName == 'None'
          ? '5 seconds'
          : (modeName.split(' ')[3] + ' ' + modeName.split(' ')[4]);
    });
    print(finalReport.length);
    setState(() {
      _report.addAll(finalReport);
    });
  }

  int findMaxCount(List<List<String>> list) {
    int max = 0;
    for (int i = 0; i < list.length; i++) {
      int count = int.parse(list[i][2]);
      if (count > max) {
        max = count;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get Report'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 15),
            onPressed: () {
              Navigator.pushNamed(context, Dashboard.id);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: line,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white70, fontSize: 25.0),
                      underline: Container(
                        height: 2,
                        width: 200.0,
                        color: Colors.lightBlueAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          line = newValue;
                        });
                        _getShifts(line);
                      },
                      items:
                          lines.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropdownButton<String>(
                      value: shiftName,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white70, fontSize: 25.0),
                      underline: Container(
                        height: 2,
                        width: 200.0,
                        color: Colors.lightBlueAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          shiftName = newValue;
                        });
                        if (newValue == 'All') {
                          setState(() {
                            shift = null;
                          });
                        } else {
                          if (shifts != null) {
                            for (Shift s in shifts) {
                              if (s.name == newValue) {
                                setState(() {
                                  shift = s;
                                });
                              }
                            }
                            print(shift.endTime);
                          } else {
                            setState(() {
                              shift = null;
                            });
                          }
                        }
                      },
                      items: shiftNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropdownButton<String>(
                      value: modeName,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white70, fontSize: 25.0),
                      underline: Container(
                        height: 2,
                        width: 200.0,
                        color: Colors.lightBlueAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          modeName = newValue;
                        });
                        switch (newValue) {
                          case 'None':
                            {
                              setState(() {
                                mode = 0;
                              });
                            }
                            break;
                          case 'At interval of 1 minute':
                            {
                              setState(() {
                                mode = 1;
                              });
                            }
                            break;
                          case 'At interval of 5 minute':
                            {
                              setState(() {
                                mode = 2;
                              });
                            }
                            break;
                          case 'At interval of 10 minute':
                            {
                              setState(() {
                                mode = 3;
                              });
                            }
                            break;
                          case 'At interval of 30 minute':
                            {
                              setState(() {
                                mode = 4;
                              });
                            }
                            break;
                          case 'At interval of 60 minute':
                            {
                              setState(() {
                                mode = 5;
                              });
                            }
                            break;
                          case 'At interval of 120 minute':
                            {
                              setState(() {
                                mode = 6;
                              });
                            }
                            break;
                        }
                      },
                      items:
                          modes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(fontSize: 20),
                        ),
                        DateInputField(
                          style: kPickDateInGetReportScreenStyles,
                          type: from,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                            ).then((date) {
                              setState(() {
                                _fromDate = date;
                                from = DateFormat('dd/MM/yyyy').format(date);
                              });
                            });
                          },
                        ),
                        DateInputField(
                          style: kPickDateInGetReportScreenStyles,
                          type: to,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                            ).then((date) {
                              setState(() {
                                _toDate = date;
                                to = DateFormat('dd/MM/yyyy').format(date);
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RoundedButton(
                      buttonName: 'Generate',
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        if (_fromDate == null || _toDate == null) {
                          _alertUser('Alert', 'Pick from and to dates');
                          return;
                        }
                        if (_fromDate.isAfter(_toDate)) {
                          _alertUser('Alert',
                              'From date must be before or on the To date');
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        await _generateReport();
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportPreviewScreen(
                              line: line,
                              shift: shiftName,
                              interval: interval,
                              maxCount: maxCount,
                              fromDate: from,
                              toDate: to,
                              report: _report,
                              startCount: startCount,
                              startTime: startTime,
                              endCount: endCount,
                              endTime: endTime,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
