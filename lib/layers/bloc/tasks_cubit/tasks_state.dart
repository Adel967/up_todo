part of 'tasks_cubit.dart';

@immutable
abstract class TasksState extends Equatable {}

class TasksInitial extends TasksState {
  @override
  List<Object?> get props => [];
}

class TasksLoading extends TasksState {
  @override
  List<Object?> get props => [];
}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  TasksLoaded({required this.tasks});

  @override
  List<Object?> get props => [this.tasks];
}

class TasksCompleting extends TasksState {
  @override
  List<Object?> get props => [];
}