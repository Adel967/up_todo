import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constants/theme.dart';
import '../../../../../injection_container.dart';
import '../../../../bloc/create_task_bloc/create_task_cubit.dart';

class PriorityDialog extends StatefulWidget {
  const PriorityDialog({super.key});

  @override
  State<PriorityDialog> createState() => _PriorityDialogState();
}

class _PriorityDialogState extends State<PriorityDialog> {
  int selectedIndex = 0;
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
                Text(
                  "Task Priority",
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
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.0, crossAxisCount: 4),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? ThemeColors.secondary
                                : Color(0XFF272727),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.flag,
                                  color: Colors.white.withOpacity(.8),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
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
                        createTaskCubit.priority = selectedIndex + 1;
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
}
