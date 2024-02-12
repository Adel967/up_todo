import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:up_todo/layers/view/screens/calendar/provider/calendar_properties.dart';
import 'package:up_todo/layers/view/widgets/task_card.dart';

import '../../../../core/constants/theme.dart';
import '../../../../core/ui/custom_app_bar.dart';
import '../../../../core/ui/waiting_widget.dart';
import '../../../../injection_container.dart';
import '../../../bloc/task_filter_bloc/task_filter_cubit.dart';
import '../../../bloc/tasks_cubit/tasks_cubit.dart';
import '../../../models/task.dart';
import '../../widgets/custom_button.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int selectedButtonIndex = 0;
  final taskFilterCubit = sl<TaskFilter>();
  final tasksCubit = sl<TasksCubit>();

  @override
  void initState() {
    super.initState();
    taskFilterCubit.getTasks(
        Provider.of<CalendarProperties>(context, listen: false).selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProperties>(context);

    return Scaffold(
        backgroundColor: ThemeColors.primary,
        body: BlocListener<TasksCubit, TasksState>(
          bloc: tasksCubit,
          listener: (context, state) {
            if (state is TasksLoaded) {
              taskFilterCubit.getTasks(provider.selectedDate);
            } else if (state is TasksCompleting) {
              taskFilterCubit.taskLoading();
            }
          },
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: CustomAppBar(title: "Calendar"),
                ),
                Container(
                  color: ThemeColors.accent,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: provider.selectedDate,
                    selectedDayPredicate: (day) =>
                        isSameDay(day, provider.selectedDate),
                    calendarFormat: CalendarFormat.week,
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
                      weekdayStyle: TextStyle(
                          color: Colors.white), // Change weekday color
                      weekendStyle: TextStyle(
                          color: Colors.white), // Change weekend color
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      provider.changeDate(focusedDay);
                      taskFilterCubit.getTasks(focusedDay);
                    },
                    calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: Colors.white),
                        weekNumberTextStyle: TextStyle(color: Colors.white),
                        weekendTextStyle: TextStyle(color: Colors.white),
                        todayTextStyle: TextStyle(color: Colors.white),
                        holidayTextStyle: TextStyle(color: Colors.white),
                        disabledTextStyle: TextStyle(color: Colors.white),
                        withinRangeTextStyle: TextStyle(color: Colors.white),
                        defaultDecoration:
                            BoxDecoration(shape: BoxShape.circle),
                        selectedDecoration: BoxDecoration(
                            color: ThemeColors.secondary,
                            shape: BoxShape.circle)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<TaskFilter, TaskFilterState>(
                        bloc: taskFilterCubit,
                        builder: (context, state) {
                          if (state is TaskFilterLoading) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 100.0),
                              child: Center(child: WaitingWidget()),
                            );
                          } else if (state is TaskFilterError) {
                            return Center(
                              child: Text(state.errorMessage),
                            );
                          } else if (state is TaskFilterLoaded) {
                            return state.completedTask.isEmpty &&
                                    state.uncompletedTask.isEmpty
                                ? Center(
                                    child: Text(
                                      "There is not any tasks in this day!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                            color: ThemeColors.accent,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                withBackground: provider
                                                        .selectedButtonIndex ==
                                                    0,
                                                title: 'Today',
                                                function: () {
                                                  provider
                                                      .changeSelectedButton(0);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Expanded(
                                              child: CustomButton(
                                                withBackground: provider
                                                        .selectedButtonIndex ==
                                                    1,
                                                title: 'Completed',
                                                function: () {
                                                  provider
                                                      .changeSelectedButton(1);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: taskLists(
                                            provider.selectedButtonIndex == 0
                                                ? state.uncompletedTask
                                                : state.completedTask,
                                            provider.selectedButtonIndex == 0
                                                ? "All tasks are completed!"
                                                : "All tasks are uncompleted!"),
                                      )
                                    ],
                                  );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget taskLists(List<Task> tasks, String emptyTitle) {
    return tasks.isNotEmpty
        ? ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return TaskCard(task: task);
            },
          )
        : Center(
            child: Text(
              emptyTitle,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
  }
}
