
import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  const Summary({Key key, @required this.value, this.type, this.isItalic})
      : super(key: key);

  final String value, type;
  final bool isItalic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type,
              style: TextStyle(
                  fontSize: 15, fontStyle: isItalic ? FontStyle.italic : null)),
          Text(value,
              style: TextStyle(
                  fontSize: 15, fontStyle: isItalic ? FontStyle.italic : null)),
        ],
      ),
    );
  }
}