import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({@required this.buttonName, @required this.color, @required this.onPressed, this.width});
  final String buttonName;
  final Function onPressed;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width??200.0,
          height: 42.0,
          child: Text(
            buttonName,
            style: TextStyle(color: Colors.white, fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}