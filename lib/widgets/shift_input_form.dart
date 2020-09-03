import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenupproductioncounter/models/shift.dart';
import 'package:tenupproductioncounter/models/shifts_data.dart';
import 'package:tenupproductioncounter/screens/set_target_screen.dart';

class ShiftInputForm extends StatefulWidget {
  @override
  _ShiftInputFormState createState() => _ShiftInputFormState();
}

class _ShiftInputFormState extends State<ShiftInputForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay startTime, endTime;
  int i;
  Shift newShift;
  String name;

  @override
  void initState() {
    startTime = TimeOfDay(hour: 0, minute: 0);
    endTime = TimeOfDay(hour: 0, minute: 0);
    super.initState();
  }

  _pickTime(bool isStartTime) async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) {
      setState(() {
        isStartTime ? startTime = t : endTime = t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.pushNamed(context, SetTargetScreen.id);
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.access_time),
                        labelText: 'Shift Name*',
                        hintText: 'Enter the name of the shift',
                    ),
                    validator: (value) => value.isEmpty ? 'can\'t be empty' : null,
                    onSaved: (value) => name = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:
                        TextEditingController(text: startTime.format(context)),
                    onTap: () {
                      _pickTime(true);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.access_time),
                      labelText: 'Start Time*',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:
                        TextEditingController(text: endTime.format(context)),
                    onTap: () {
                      _pickTime(false);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.access_time),
                      labelText: 'End Time*',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        newShift = Shift(
                            name: name,
                            startTime: startTime,
                            endTime: endTime,
                        );
                        Provider.of<ShiftsData>(context, listen: false).add(newShift);
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
