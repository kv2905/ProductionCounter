import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/models/shift.dart';
import 'package:tenupproductioncounter/screens/set_target_screen.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:tenupproductioncounter/models/shifts_data.dart';
import 'package:tenupproductioncounter/widgets/shift_tile.dart';

class ShiftSettingsScreen extends StatefulWidget {
  static const String id = 'shift_setting_screen';
  @override
  _ShiftSettingsScreenState createState() => _ShiftSettingsScreenState();
}

class _ShiftSettingsScreenState extends State<ShiftSettingsScreen> {
  String line = 'Line 1';
  List<Shift> shifts = ShiftsData().shifts;
  TimeOfDay startTime, endTime;

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

  @override
  void initState() {
    super.initState();
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Settings'),
      ),
      body: Column(
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
                });
              },
              items: <String>['Line 1', 'Line 2', 'Line 3', 'Line 4']
                  .map<DropdownMenuItem<String>>((String value) {
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
              itemCount: shifts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      ShiftTile(
                        shiftName: shifts[index].name,
                        setStartTimeCallback: () async {
                          await _pickStartTime();
                          shifts[index].shiftStartTime = startTime;
                          print(
                              'start time of shift $index is ${shifts[index].startTime}');
                        },
                        setEndTimeCallback: () async {
                          await _pickEndTime();
                          shifts[index].shiftEndTime = endTime;
                          print(
                              'end time of shift $index is ${shifts[index].endTime}');
                        },
                        startTime: shifts[index].startTime,
                        endTime: shifts[index].endTime,
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
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  right: -40.0,
                                  top: -40.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SetTargetScreen.id);
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                                Form(
//                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text("Submit"),
                                          onPressed: () {
//                                            if (_formKey.currentState
//                                                .validate()) {
//                                              _formKey.currentState.save();
//                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  color: Colors.lightBlueAccent,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () {},
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
