import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tenupproductioncounter/models/shifts_data.dart';
import 'package:tenupproductioncounter/screens/dashboard.dart';
import 'package:tenupproductioncounter/screens/get_report_screen.dart';
import 'package:tenupproductioncounter/screens/set_target_screen.dart';
import 'package:tenupproductioncounter/screens/shift_settings_screen.dart';
import 'package:tenupproductioncounter/screens/welcome_screen.dart';
import 'package:tenupproductioncounter/screens/login_screen.dart';
import 'package:tenupproductioncounter/screens/wifi_settings_screen.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => ShiftsData(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Smart Production Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        WifiSettingsScreen.id: (context) => WifiSettingsScreen(),
        Dashboard.id: (context) => Dashboard(),
        SetTargetScreen.id: (context) => SetTargetScreen(),
        ShiftSettingsScreen.id: (context) => ShiftSettingsScreen(),
        GetReportScreen.id: (context) => GetReportScreen(),
      },
    );
  }
}
