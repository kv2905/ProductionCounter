import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/screens/pdf_preview_screen.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:tenupproductioncounter/widgets/date_input_field.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GetReportScreen extends StatefulWidget {
  static const String id = 'get_report_screen';
  @override
  _GetReportScreenState createState() => _GetReportScreenState();
}

class _GetReportScreenState extends State<GetReportScreen> {
  String line = 'Line 1', shift = 'Shift 1', from = 'from', to = 'to';
  DateTime _fromDate, _toDate;
  final pdf = pw.Document();
  final dbRef =
      FirebaseDatabase.instance.reference().child('Company1').child('line1');

  _getDataFromFirebase() {
    dbRef.once().then((DataSnapshot snap){
      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key,values) {
        print(values['count']);
      });
    });
  }

  _writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text('Production Counter Report',
                  style: pw.TextStyle(fontSize: 20)),
            ),
            pw.Table.fromTextArray(data: <List<String>>[
              <String>['Date', 'Time', 'Count'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
              <String>['05/10/2020', '12:30', '135'],
            ]),
          ];
        },
      ),
    );
  }

  Future _savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File('$documentPath/report.pdf');
    file.writeAsBytesSync(pdf.save());
  }

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
              items: <String>['Line 1', 'Line 2', 'Line 3', 'Line 4', 'All']
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
              items: <String>['Shift 1', 'Shift 2', 'Shift 3', 'Shift 4', 'All']
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
                  style: kPickDateInGetReportScreenStyles,
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
                  style: kPickDateInGetReportScreenStyles,
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
              onPressed: () async {
                _writeOnPdf();
                await _savePdf();
                _getDataFromFirebase();
                Directory documentDirectory =
                    await getApplicationDocumentsDirectory();
                String documentPath = documentDirectory.path;
                String fullPath = '$documentPath/report.pdf';
                print(fullPath);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewScreen(
                      path: fullPath,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
