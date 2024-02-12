import 'package:flutter/cupertino.dart';

class CalendarProperties extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  int _selectedButtonIndex = 0;

  changeDate(DateTime dateTime) {
    _selectedDate = dateTime;
    _selectedButtonIndex = 0;
    notifyListeners();
  }

  changeSelectedButton(int index) {
    _selectedButtonIndex = index;
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;
  int get selectedButtonIndex => _selectedButtonIndex;
}
