part of 'task_filter_cubit.dart';

@immutable
abstract class TaskFilterState extends Equatable {}

class IndexInitial extends TaskFilterState {
  @override
  List<Object?> get props => [];
}

class TaskFilterLoading extends TaskFilterState {
  @override
  List<Object?> get props => [];
}

class TaskFilterLoaded extends TaskFilterState {
  final List<Task> uncompletedTask;
  final List<Task> completedTask;

  TaskFilterLoaded(
      {this.uncompletedTask = const [], this.completedTask = const []});

  @override
  List<Object?> get props => [this.uncompletedTask, this.completedTask];
}

class TaskFilterError extends TaskFilterState {
  final String errorMessage;

  TaskFilterError({required this.errorMessage});

  @override
  List<Object?> get props => [this.errorMessage];
}
