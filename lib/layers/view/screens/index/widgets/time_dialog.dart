import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:up_todo/core/enum.dart' as Enums;
import '../../../../../core/constants/theme.dart';
import '../../../../../injection_container.dart';
import '../../../../bloc/create_task_bloc/create_task_cubit.dart';

class TimeDialog extends StatefulWidget {
  const TimeDialog({super.key});

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  int hours = DateTime.now().hour;
  int minutes = DateTime.now().minute;
  Enums.Time time = Enums.Time.AM;
  final createTaskCubit = sl<CreateTaskCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime currentDate = DateTime.now();
    if (currentDate.hour > 12) {
      hours = currentDate.hour - 12;
      time = Enums.Time.PM;
    }
  }

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
                Text(
                  "Choose Time",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  color: Color(0XFF979797),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customCupertinoPicker(
                        List.generate(
                                12,
                                (index) =>
                                    (index + 1).toString().padLeft(2, '0'))
                            .toList(),
                        hours - 1, (int value) {
                      hours = value + 1;
                      setState(() {});
                    }),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ":",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    customCupertinoPicker(
                        List.generate(60,
                                (index) => (index).toString().padLeft(2, '0'))
                            .toList(),
                        minutes, (int value) {
                      minutes = value;
                      setState(() {});
                    }),
                    SizedBox(
                      width: 15,
                    ),
                    customCupertinoPicker(
                        Enums.getListOfTime()
                            .map((e) => Enums.TimeToString(e))
                            .toList(),
                        Enums.getListOfTime().indexOf(time), (int value) {
                      setState(() {
                        time = Enums.getListOfTime()[value];
                      });
                    }, isLooping: false),
                  ],
                ),
                SizedBox(
                  height: 20,
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
                      onPressed: () {
                        createTaskCubit.time =
                            "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")} ${Enums.TimeToString(time)}";
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save",
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

  Container customCupertinoPicker(
      List<String> items, int initialValue, Function(int) function,
      {bool isLooping = true}) {
    int selectedValue = initialValue;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color: Color(0XFF272727), borderRadius: BorderRadius.circular(4)),
      child: CupertinoPicker(
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent,
          ),
          looping: isLooping,
          itemExtent: 28,
          scrollController:
              FixedExtentScrollController(initialItem: initialValue),
          onSelectedItemChanged: (value) {
            function(value);
            setState(() {
              selectedValue = value;
            });
          },
          children: List.generate(
              items.length,
              (index) => Text(
                    items[index],
                    style: TextStyle(
                      fontSize: index == selectedValue ? 20 : 18,
                      color: index == selectedValue
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ))),
    );
  }
}
