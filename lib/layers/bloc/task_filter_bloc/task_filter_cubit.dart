import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:up_todo/core/constants.dart';
import '../../../injection_container.dart';
import '../../models/task.dart';
import '../tasks_cubit/tasks_cubit.dart';

part 'task_filter_state.dart';

class TaskFilter extends Cubit<TaskFilterState> {
  TaskFilter() : super(IndexInitial());

  final tasksCubit = sl<TasksCubit>();

  getTasks(DateTime dateTime, {String search = ""}) async {
    try {
      List<Task> tasks = [];
      if (tasksCubit.state is TasksLoaded) {
        tasks = List.from((tasksCubit.state as TasksLoaded).tasks);
      }
      tasks =
          List.from(tasks.where((element) => element.title.contains(search)));
      List<Task> todayCompletedTasks = [];
      List<Task> todayUnCompletedTasks = [];
      for (var i in tasks) {
        if (Constants.checkIfSameDay(i.date, dateTime)) {
          if (i.isCompleted) {
            todayCompletedTasks.add(i);
          } else {
            todayUnCompletedTasks.add(i);
          }
        }
      }
      emit(TaskFilterLoaded(
          uncompletedTask: todayUnCompletedTasks,
          completedTask: todayCompletedTasks));
    } catch (ex) {
      emit(
          TaskFilterError(errorMessage: "There is an error, try again later!"));
    }
  }

  taskLoading() {
    emit(TaskFilterLoading());
  }
}
