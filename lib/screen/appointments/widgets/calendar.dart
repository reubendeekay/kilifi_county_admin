import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class UserCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: kBackground,
        ),
        width: 280,
        child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            onDateChanged: (time) => print(time)));
  }
}
