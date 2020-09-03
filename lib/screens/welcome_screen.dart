import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/screens/login_screen.dart';
import 'package:tenupproductioncounter/screens/wifi_settings_screen.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        iconSize: 40,
                        onPressed: (){
                          Navigator.pushNamed(context, WifiSettingsScreen.id);
                        },
                      ),
                      Text('WIFI'),
                      Text('Settings')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 120),
            Text(
              'Smart Production Counter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              buttonName: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
