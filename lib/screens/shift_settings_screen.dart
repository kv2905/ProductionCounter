import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';

class ShiftSettingsScreen extends StatefulWidget {
  static const String id = 'shift_setting_screen';
  @override
  _ShiftSettingsScreenState createState() => _ShiftSettingsScreenState();
}

class _ShiftSettingsScreenState extends State<ShiftSettingsScreen> {
  String line = 'Line 1';

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
          Expanded(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Shift',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Start',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'End',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Shift 1')),
                    DataCell(Text('10:30'), showEditIcon: true),
                    DataCell(Text('2:30'), showEditIcon: true),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Shift 2')),
                    DataCell(Text('3:30'), showEditIcon: true),
                    DataCell(Text('8:30'), showEditIcon: true),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Shift 3')),
                    DataCell(Text('9:30'), showEditIcon: true),
                    DataCell(Text('1:30'), showEditIcon: true),
                  ],
                ),
              ],
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
                  onPressed: (){},
                  color: Colors.lightBlueAccent,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: (){},
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
