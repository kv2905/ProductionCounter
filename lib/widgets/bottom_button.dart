import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton({@required this.buttonTitle, @required this.onTap});
  final String buttonTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kLargeButtonTextStyle,
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 20.0),
        height: 80.0,
        color: Color(0xFF42906A),
      ),
    );
  }
}