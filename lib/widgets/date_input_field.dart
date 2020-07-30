import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  const DateInputField({@required this.type, @required this.onTap});

  final String type;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
          IconButton(
            icon: Icon(Icons.arrow_drop_down),
            onPressed: onTap,
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.lightBlueAccent),
        ),
      ),
    );
  }
}
