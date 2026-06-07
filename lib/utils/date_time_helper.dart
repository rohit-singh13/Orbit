import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<DateTime?> pickDate(BuildContext context) async {
    return await showDatePicker(
    context: context,
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    initialDate: DateTime(2005),
    );
  }
}