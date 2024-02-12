import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/layers/view/screens/index/widgets/time_dialog.dart';

import '../../../../../injection_container.dart';
import '../../../../bloc/create_task_bloc/create_task_cubit.dart';

class DateDialog extends StatefulWidget {
  const DateDialog({super.key});

  @override
  State<DateDialog> createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  DateTime _selectedDay = DateTime.now();
  final createTaskCubit = sl<CreateTaskCubit>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: ThemeColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: Colors.white),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      )),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle:
                        TextStyle(color: Colors.white), // Change weekday color
                    weekendStyle:
                        TextStyle(color: Colors.white), // Change weekend color
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekNumberTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.white),
                      holidayTextStyle: TextStyle(color: Colors.white),
                      disabledTextStyle: TextStyle(color: Colors.white),
                      withinRangeTextStyle: TextStyle(color: Colors.white),
                      defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                          color: ThemeColors.secondary,
                          shape: BoxShape.circle)),
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: ThemeColors.secondary, fontSize: 16),
                      ),
                    )),
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                          backgroundColor:
                              MaterialStateProperty.all(ThemeColors.secondary)),
                      onPressed: () async {
                        createTaskCubit.date = _selectedDay;
                        Navigator.of(context).pop();
                        await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => TimeDialog());
                      },
                      child: Text(
                        "Choose Time",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
