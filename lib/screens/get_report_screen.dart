import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:tenupproductioncounter/widgets/date_input_field.dart';

class GetReportScreen extends StatefulWidget {
  static const String id = 'get_report_screen';
  @override
  _GetReportScreenState createState() => _GetReportScreenState();
}

class _GetReportScreenState extends State<GetReportScreen> {
  String line = 'Line 1', shift = 'Shift 1', from = 'from', to = 'to';
  DateTime _fromDate, _toDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Report'),
      ),
      body: Padding(
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
              },
              items: <String>['Line 1', 'Line 2', 'Line 3', 'Line 4']
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
                  type: from,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate:
                          _fromDate == null ? DateTime.now() : _fromDate,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2100),
                    ).then((date) {
                      setState(() {
                        _fromDate = date;
                        from = DateFormat('dd/MM/yyyy').format(date);
                      });
                    });
                  },
                ),
                DateInputField(
                  type: to,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: _toDate == null ? DateTime.now() : _toDate,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2100),
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}