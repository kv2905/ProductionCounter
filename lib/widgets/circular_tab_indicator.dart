import 'package:flutter/material.dart';


class  CircleTabIndicator extends StatelessWidget {
  CircleTabIndicator({this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: (){},
      elevation: 2.0,
      fillColor: color,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minHeight: 15.0, minWidth: 15.0),
      shape: CircleBorder(),
    );
  }
}


