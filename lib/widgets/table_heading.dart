import 'package:flutter/material.dart';

class TableHeading extends StatelessWidget {
  TableHeading({@required this.heading, this.flex});
  final Text heading;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: heading);
  }
}