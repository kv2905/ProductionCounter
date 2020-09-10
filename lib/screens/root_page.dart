import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tenupproductioncounter/screens/login_screen.dart';
import 'package:tenupproductioncounter/screens/welcome_screen.dart';

class RootPage extends StatefulWidget {
  static const String id = 'root_page';
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {
    return getValueForScreenType<bool>(context: context, desktop: true, mobile: false) ?  LoginScreen() : WelcomeScreen();
  }
}
