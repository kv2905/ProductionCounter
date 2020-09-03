import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/models/shift.dart';
import 'package:tenupproductioncounter/screens/dashboard.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:tenupproductioncounter/models/shifts_data.dart';
import 'package:tenupproductioncounter/widgets/shift_input_form.dart';
import 'package:tenupproductioncounter/widgets/shift_tile.dart';

class ShiftSettingsScreen extends StatefulWidget {
  static const String id = 'shift_setting_screen';
  @override
  _ShiftSettingsScreenState createState() => _ShiftSettingsScreenState();
}

class _ShiftSettingsScreenState extends State<ShiftSettingsScreen> {
  String line;
  List<String> lines = [];
  TimeOfDay startTime, endTime;
  bool isLoading;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('Company1');

  _pickStartTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: startTime);
    if (t != null)
      setState(() {
        startTime = t;
      });
  }

  _pickEndTime() async {
    TimeOfDay t1 = await showTimePicker(context: context, initialTime: endTime);
    if (t1 != null)
      setState(() {
        endTime = t1;
      });
  }

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
    setState(() {
      isLoading = false;
    });
  }
  
  _getShifts(String line) {
    Provider.of<ShiftsData>(context, listen: false).clearShifts();
    dbRef.child(line).child('shifts').once().then((DataSnapshot snap){
      Map<dynamic, dynamic> data = snap.value;
      if(data != null) {
        data.forEach((key, value) {
          Shift newShift = Shift(name: value['name']);
          newShift.startTime = stringToTimeOfDay(value['startTime']);
          newShift.endTime = stringToTimeOfDay(value['endTime']);
          Provider.of<ShiftsData>(context, listen: false).add(newShift);
        });
      }
    });
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  _saveShiftData(ShiftsData shiftsData) async {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < shiftsData.shiftCount; i++) {
      await dbRef
          .child(line)
          .child('shifts')
          .child(shiftsData.shifts[i].name)
          .set(shiftsData.shifts[i].toJSON());
    }
    setState(() {
      isLoading = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Shifts saved to data base'),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
    isLoading = true;
    line = 'line1';
    _getLines();
    _getShifts(line);
  }

  @override
  Widget build(BuildContext context) {
    var shifts = context.watch<ShiftsData>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Settings'),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: DropdownButton<String>(
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
                        _getShifts(line);
                      });
                    },
                    items: lines.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      TableHeading(
                        heading: Text(
                          'Shift Name',
                          style: kTableHeadingStyles,
                        ),
                        flex: 1,
                      ),
                      TableHeading(
                        heading: Text(
                          'Start Time',
                          textAlign: TextAlign.start,
                          style: kTableHeadingStyles,
                        ),
                        flex: 1,
                      ),
                      TableHeading(
                        heading: Text(
                          'End Time',
                          textAlign: TextAlign.start,
                          style: kTableHeadingStyles,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: shifts.shiftCount,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            ShiftTile(
                              shiftName: shifts.shifts[index].name,
                              setStartTimeCallback: () async {
                                await _pickStartTime();
                                shifts.shifts[index].shiftStartTime = startTime;
                                await dbRef
                                    .child(line)
                                    .child('shifts')
                                    .child(shifts.shifts[index].name)
                                    .update(shifts.shifts[index].toJSON());
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Changes Saved',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.black38,
                                  ),
                                );
                              },
                              setEndTimeCallback: () async {
                                await _pickEndTime();
                                shifts.shifts[index].shiftEndTime = endTime;
                                await dbRef
                                    .child(line)
                                    .child('shifts')
                                    .child(shifts.shifts[index].name)
                                    .update(shifts.shifts[index].toJSON());
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Changes Saved',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.black38,
                                  ),
                                );
                              },
                              startTime: shifts.shifts[index].startTime,
                              endTime: shifts.shifts[index].endTime,
                              deleteShiftCallback: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Alert'),
                                      content: Text('Delete the Shift?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("YES"),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              isLoading = true;
                                            });
                                            shifts.shiftCount > 1
                                                ? await dbRef
                                                    .child(line)
                                                    .child('shifts')
                                                    .child(shifts
                                                        .shifts[index].name)
                                                    .remove()
                                                : await dbRef
                                                    .child(line)
                                                    .child('shifts')
                                                    .remove();
                                            setState(() {
                                              isLoading = false;
                                            });
                                            shifts.del(index);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("NO"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedButton(
                        width: 120,
                        buttonName: 'New',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShiftInputForm();
                            },
                          );
                        },
                        color: Colors.lightBlueAccent,
                      ),
                      RoundedButton(
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          _saveShiftData(shifts);
                        },
                        buttonName: 'Save',
                        width: 120,
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class TableHeading extends StatelessWidget {
  TableHeading({@required this.heading, this.flex});
  final Text heading;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: heading);
  }
}
