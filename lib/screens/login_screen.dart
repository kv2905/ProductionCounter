import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tenupproductioncounter/widgets/custom_logo.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tenupproductioncounter/screens/dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: getValueForScreenType<bool>(context: context, desktop: true, mobile: false) ? EdgeInsets.symmetric(vertical: 24, horizontal: 512) : EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLogo(
                  name: 'Production Counter',
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Username',
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  buttonName: 'Login',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, Dashboard.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
