import 'package:flutter/material.dart';
import 'line.dart';

class CustomLogo extends StatelessWidget {
  CustomLogo({@required this.name, this.length});
  final String name;
  final double length;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Line(
              marginLeft: 30.0,
              marginRight: 10.0,
              height: 6.5,
              width: 70.5,
              borderRadius: 19.0,
              color: Color(0xFF42906A),
            ),
            Text(
              'Tenup-Tech',
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFFF5F5F5),
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 32.0,
              color: Color(0xFFF5F5F5),
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Line(
          marginLeft: 30.0,
          marginRight: 10.0,
          height: 6.5,
          width: length,
          borderRadius: 19.0,
          color: Color(0xFFF5F5F5),
        ),
      ],
    );
  }
}
