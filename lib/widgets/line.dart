import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  Line(
      {@required this.color,
        this.width,
        this.height,
        this.borderRadius,
        this.marginLeft,
        this.marginRight});
  final double height, width, marginLeft, marginRight, borderRadius;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft, right: marginRight),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
    );
  }
}