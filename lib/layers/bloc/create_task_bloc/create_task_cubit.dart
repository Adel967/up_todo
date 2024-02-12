import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:up_todo/layers/models/task.dart';

import '../../../core/app/state/app_state.dart';
import '../../../injection_container.dart';
import '../../models/category.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());

  CollectionReference categories = FirebaseFirestore.instance
      .collection('user_data')
      .doc(sl<AppStateModel>().currentUser!.username)
      .collection("tasks");

  final tasksCubit = sl<TasksCubit>();

  String? taskTitle;
  String? taskDescription;
  DateTime? date;
  String? time;
  int? priority;
  Category? category;

  isFieldsFilled() {
    if (taskTitle != null &&
        taskTitle!.isNotEmpty &&
        taskDescription != null &&
        taskDescription!.isNotEmpty &&
        time != null &&
        time!.isNotEmpty &&
        date != null &&
        priority != null &&
        category != null) {
      return true;
    }
    return false;
  }

  addNewTask() async {
    if (isFieldsFilled()) {
      emit(CreateTaskLoading());
      Task task = Task(
          title: taskTitle!,
          description: taskDescription!,
          category: category!,
          priority: priority!,
          date: date!,
          isCompleted: false,
          time: time!);
      final querySnapshot = await categories.add(task.toMap());
      if (querySnapshot.id.isNotEmpty) {
        tasksCubit.getTasks();
        emit(CreateTaskLoaded());
        resetValues();
      } else {
        emit(CreateTaskError(
            errorMessage: "There is an error, try again later!"));
      }
    }
  }

  resetValues() {
    taskTitle = null;
    taskDescription = null;
    date = null;
    time = null;
    priority = null;
    category = null;
  }
}
