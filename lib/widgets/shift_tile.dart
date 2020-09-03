import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShiftTile extends StatelessWidget {
  static const TimeOfDay initTime = TimeOfDay(hour: 0, minute: 0);

  ShiftTile(
      {this.endTime = initTime,
      this.startTime = initTime,
      this.setEndTimeCallback,
      this.setStartTimeCallback,
      this.shiftName,
      this.deleteShiftCallback});
  final String shiftName;
  TimeOfDay startTime, endTime;
  final Function setStartTimeCallback, setEndTimeCallback, deleteShiftCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onLongPress: deleteShiftCallback,
            child: Text(shiftName),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(startTime == null ? '00:00' : startTime.format(context)),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                ),
                onPressed: setStartTimeCallback,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(endTime == null ? '00:00' : endTime.format(context)),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                ),
                onPressed: setEndTimeCallback,
              )
            ],
          ),
        ),
      ],
    );
  }
}
