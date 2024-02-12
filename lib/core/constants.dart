import 'package:flutter/material.dart';

import 'constants/theme.dart';

class Constants {
  static final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Color(0XFF979797)));

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static String extractTimeFromDateTime(DateTime dateTime) {
    return dateTime.hour.toString().padLeft(2, "0") +
        ":" +
        dateTime.minute.toString().padLeft(2, "0");
  }

  static bool checkIfToday(DateTime dateToCheck) {
    final now = DateTime.now();
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    final today = DateTime(now.year, now.month, now.day);

    if (aDate == today) {
      return true;
    }

    return false;
  }

  static bool checkIfSameDay(DateTime dateToCheck, DateTime date) {
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    final dateToCheckWith = DateTime(date.year, date.month, date.day);

    if (aDate == dateToCheckWith) {
      return true;
    }

    return false;
  }

  static showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(title),
      backgroundColor: ThemeColors.secondary,
    ));
  }
}
