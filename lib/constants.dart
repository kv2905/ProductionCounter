import 'package:flutter/material.dart';

const kCardColor = Color(0xFF111328);
const kLabelTextStyle = TextStyle(color: Color(0xFF8D8E98), fontSize: 18.0);
const kNumberTextStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900);
const kLargeButtonTextStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
const kDrawerListTileStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);
const kCardLeadText = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.blueGrey),
  contentPadding:
  EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTestFieldDecorationForOneSidedBorders = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.blueGrey),
  contentPadding:
  EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
  enabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTableHeadingStyles = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70);