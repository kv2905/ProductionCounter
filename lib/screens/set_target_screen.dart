import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/widgets/date_input_field.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:intl/intl.dart';

class SetTargetScreen extends StatefulWidget {
  static const String id = 'set_target_screen';
  @override
  _SetTargetScreenState createState() => _SetTargetScreenState();
}

class _SetTargetScreenState extends State<SetTargetScreen> {
  String line = 'Line 1';
  String shift = 'Shift 1';
  int target = 1000;
  DateTime _date;
  String dateString = 'Pick Date';
  final nameHolder = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Set Target'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              },
              items: <String>['Line 1', 'Line 2', 'Line 3', 'Line 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 25,),
            DropdownButton<String>(
              value: shift,
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
                  shift = newValue;
                });
              },
              items: <String>['Shift 1', 'Shift 2', 'Shift 3', 'Shift 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 25,),
            TextField(
              controller: nameHolder,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                target = int.parse(value);
              },
              decoration: kTestFieldDecorationForOneSidedBorders.copyWith(
                hintText: 'Enter the target',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 25,),
            DateInputField(
              style: kPickDateInSetTargetScreenStyles,
              type: dateString,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate:
                  _date == null ? DateTime.now() : _date,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2100),
                ).then((date) {
                  setState(() {
                    _date = date;
                    dateString = DateFormat('dd/MM/yyyy').format(date);
                  });
                });
              },
            ),
            SizedBox(height: 35,),
            RoundedButton(
              buttonName: 'Send',
              color: Colors.lightBlueAccent,
              onPressed: () {
                nameHolder.clear();
                setState(() {
                  dateString = 'Pick Date';
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
