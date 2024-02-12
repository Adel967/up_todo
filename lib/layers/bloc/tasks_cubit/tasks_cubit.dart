import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/app/state/app_state.dart';
import '../../../injection_container.dart';
import '../../models/task.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  late CollectionReference _tasksCollection;

  getTasks() async {
    _tasksCollection = FirebaseFirestore.instance
        .collection('user_data')
        .doc(sl<AppStateModel>().currentUser!.username)
        .collection("tasks");
    emit(TasksLoading());
    final querySnapshot = await _tasksCollection.get();
    List<Task> tasks =
        querySnapshot.docs.map((doc) => Task.fromMap(doc)).toList();
    emit(TasksLoaded(tasks: tasks));
  }

  completeTask(Task task) async {
    emit(TasksCompleting());
    await _tasksCollection.doc(task.id).update({taskKeys.isCompleted: true});
    await getTasks();
  }

}
