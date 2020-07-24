import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenupproductioncounter/screens/get_report_screen.dart';
import 'package:tenupproductioncounter/screens/shift_settings_screen.dart';
import 'package:tenupproductioncounter/widgets/option_tile.dart';
import 'package:tenupproductioncounter/screens/set_target_screen.dart';

FirebaseUser loggedInUser;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 220,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(Icons.clear),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, GetReportScreen.id);
                },
                optionName: 'Get Report',
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, SetTargetScreen.id);
                },
                optionName: 'Set Target',
              ),
              OptionTile(
                onTap: () {
                  Navigator.pushNamed(context, ShiftSettingsScreen.id);
                },
                optionName: 'Shift Settings',
              ),
              OptionTile(
                onTap: () {
                  _auth.signOut();
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                },
                optionName: 'LogOut',
              )
            ],
          ),
        ),
      ),
    );
  }
}

