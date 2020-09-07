import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/screens/get_report_screen.dart';
import 'package:tenupproductioncounter/widgets/summary.dart';
import 'package:tenupproductioncounter/widgets/table_heading.dart';
import 'package:tenupproductioncounter/screens/pdf_preview_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ReportPreviewScreen extends StatefulWidget {
  ReportPreviewScreen(
      {this.interval,
      this.shift,
      this.maxCount,
      this.line,
      this.fromDate,
      this.toDate,
      this.report,
      this.startCount,
      this.startTime,
      this.endCount,
      this.endTime});
  final String line,
      shift,
      interval,
      maxCount,
      fromDate,
      toDate,
      startTime,
      endTime,
      startCount,
      endCount;

  final List<List<String>> report;

  @override
  _ReportPreviewScreenState createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends State<ReportPreviewScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading;
  final pdf = pw.Document();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  _writeOnPdf(List<List<String>> list) {
    print(list.length);
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(children: <pw.Widget>[
              pw.Text(
                'Production Counter Report',
                style: pw.TextStyle(fontSize: 40, color: PdfColors.cyan),
              ),
              pw.Divider(thickness: 4),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text('Line: ' + widget.line,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('Shift: ' + widget.shift,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('Interval: ' + widget.interval,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('Maximum Count: ' + widget.maxCount,
                            style: pw.TextStyle(fontSize: 15)),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text('From Date: ' + widget.fromDate,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('Start Time: ' + widget.startTime,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('Start Count: ' + widget.startCount,
                            style: pw.TextStyle(fontSize: 15)),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text('To Date: ' + widget.toDate,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('End Time: ' + widget.endTime,
                            style: pw.TextStyle(fontSize: 15)),
                        pw.Text('End Count: ' + widget.endCount,
                            style: pw.TextStyle(fontSize: 15)),
                      ]),
                ]),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Date', 'Time', 'Count'],
              data: list,
            ),
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
        title: Text('Report'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 15),
          onPressed: () {
            Navigator.pushNamed(context, GetReportScreen.id);
          },
        ),
        actions: [
          FlatButton(
            child: Text('Generate PDF'),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              _writeOnPdf(widget.report);
              await _savePdf();
              Directory documentDirectory =
                  await getApplicationDocumentsDirectory();
              String documentPath = documentDirectory.path;
              String fullPath = '$documentPath/report.pdf';
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SafeArea(
                    child: PdfPreviewScreen(
                      path: fullPath,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Text(
                    'Production Counter Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.lightBlueAccent),
                  ),
                ),
                Container(
                    width: 200,
                    child: Divider(thickness: 4, color: Color(0xFF42906A))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Summary(
                              type: 'Line: ',
                              value: widget.line,
                              isItalic: true),
                          Summary(
                              type: 'Shift: ',
                              value: widget.shift,
                              isItalic: true),
                          Summary(
                              type: 'Form Date: ',
                              value: widget.fromDate,
                              isItalic: false),
                          Summary(
                              type: 'Start Time: ',
                              value: widget.startTime,
                              isItalic: false),
                          Summary(
                              type: 'Start Count: ',
                              value: widget.startCount,
                              isItalic: false),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Summary(
                              type: 'Interval: ',
                              value: widget.interval,
                              isItalic: true),
                          Summary(
                              type: 'Maximum Count: ',
                              value: widget.maxCount,
                              isItalic: true),
                          Summary(
                              type: 'To Date: ',
                              value: widget.toDate,
                              isItalic: false),
                          Summary(
                              type: 'End Time: ',
                              value: widget.endTime,
                              isItalic: false),
                          Summary(
                              type: 'End Count: ',
                              value: widget.endCount,
                              isItalic: false),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      TableHeading(
                        heading: Text(
                          'Date',
                          textAlign: TextAlign.center,
                          style: kTableHeadingStyles,
                        ),
                        flex: 1,
                      ),
                      TableHeading(
                        heading: Text(
                          'Time',
                          textAlign: TextAlign.center,
                          style: kTableHeadingStyles,
                        ),
                        flex: 1,
                      ),
                      TableHeading(
                        heading: Text(
                          'Count',
                          textAlign: TextAlign.center,
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
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.report.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.report[index][0],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.report[index][1],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.report[index][2],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 2)
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
