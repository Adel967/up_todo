import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/task.dart';
import '../../../widgets/task_card.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.title, required this.tasks});
  final String title;
  final List<Task> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  double turns = 0.0;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isVisible) {
                turns -= 1 / 2;
              } else {
                turns += 1 / 2;
              }
              isVisible = !isVisible;
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 16, color: Colors.white.withOpacity(0.9)),
                ),
                SizedBox(
                  width: 5,
                ),
                AnimatedRotation(
                  turns: turns,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: widget.tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(
                task: widget.tasks[index],
              );
            },
          ),
        )
      ],
    );
  }
}
