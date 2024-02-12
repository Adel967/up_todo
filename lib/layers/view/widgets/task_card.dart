import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:up_todo/layers/models/task.dart';

import '../../../core/constants.dart';
import '../../../core/constants/theme.dart';
import '../../../injection_container.dart';

class TaskCard extends StatelessWidget {
  TaskCard({super.key, required this.task, this.function});

  final Task task;
  final Function(Task)? function;
  final tasksCubit = sl<TasksCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          task.isCompleted
              ? Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : IconButton(
                  onPressed: () => tasksCubit.completeTask(task),
                  icon: Icon(
                    Icons.circle_outlined,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    task.title,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today At ${task.time}",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: task.category.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                task.category.icon,
                                size: 15,
                                color:
                                    Constants.darken(task.category.color, .3),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                task.category.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.secondary),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flag,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                task.priority.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
