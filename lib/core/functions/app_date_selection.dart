import 'package:flutter/material.dart';

Future<void> appSelectDate(
  BuildContext ctx, {
  DateTime? date,
  required Function(DateTime pickDate) onPickDate,
}) async {
  final initialDate = date;

  DateTime? pickDate = await showDatePicker(
    context: ctx,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(DateTime.now().year + 1),
  );

  if (pickDate != null) {
    onPickDate(pickDate);
  }
}
