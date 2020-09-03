import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/screens/dashboard.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';

class SetTargetScreen extends StatefulWidget {
  static const String id = 'set_target_screen';
  @override
  _SetTargetScreenState createState() => _SetTargetScreenState();
}

class _SetTargetScreenState extends State<SetTargetScreen> {
  String line = 'line1';
  List<String> lines = ['All'];
  int target;
  bool isLoading;
  final nameHolder = TextEditingController();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('Company1');

  @override
  void initState() {
    isLoading = true;
    _getLines();
    super.initState();
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

  _updateTarget(BuildContext context) {
    if (target == null) {
      _alertUser('Error', 'Target not set!');
      return;
    }
    if (target == 0 || target > 999999) {
      _alertUser(
          'Try Again!', 'Target can not be set to zero or more than 999999.');
      nameHolder.clear();
      return;
    }
    if(line == 'All') {
      for(int i=1; i<lines.length; i++) {
        dbRef.child('line$i').update({'target': target}).then((_) {
          nameHolder.clear();
          _alertUser('', 'Target Updated!!');
        }).catchError((onError) {
          _alertUser('', 'Some error occurred!!');
        });
      }
    }
    else {
      dbRef.child(line).update({'target': target}).then((_) {
        nameHolder.clear();
        _alertUser('', 'Target Updated!!');
      }).catchError((onError) {
        _alertUser('', 'Some error occurred!!');
      });
    }
    setState(() {
      target = null;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Set Target'),
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
                    items: lines.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
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
                  SizedBox(
                    height: 75,
                  ),
                  RoundedButton(
                    buttonName: 'Send',
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      _updateTarget(context);
                    },
                  )
                ],
              ),
            ),
    );
  }
}
