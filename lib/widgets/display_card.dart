import 'package:flutter/material.dart';
import 'package:tenupproductioncounter/constants.dart';
import 'package:tenupproductioncounter/widgets/circular_tab_indicator.dart';

class DisplayCard extends StatelessWidget {
  DisplayCard(
      {this.onPress,
      this.line,
      this.left,
      this.done,
      this.target,
      this.shift,
      @required this.tabColor});
  final Function onPress;
  final String line, shift;
  final int target, left, done;
  final Color tabColor;

  Widget _getCard({String name, int number, Color color}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(name, style: TextStyle(color: color, fontSize: 18.0)),
          Text(
            '$number',
            style: TextStyle(color: color, fontSize: 18.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15.0, left: 25.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  line,
                  style: kCardLeadText,
                ),
              ),
              CircleTabIndicator(color: tabColor),
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 15.0, right: 15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  shift,
                  style: kCardLeadText,
                ),
              ),
            ],
          ),
          Container(
            child: Container(
              height: 150.0,
              child: Row(
                children: [
                  _getCard(name: 'Target', number: 1000, color: Colors.lightBlueAccent),
                  _getCard(name: 'Remaining', number: left, color: Colors.red),
                  _getCard(name: 'Completed', number: done, color: Colors.green)
                ],
              ),
            ),
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: kCardColor, borderRadius: BorderRadius.circular(10.0)),
          ),
        ],
      ),
    );
  }
}
