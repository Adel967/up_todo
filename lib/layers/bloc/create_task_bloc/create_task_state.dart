part of 'create_task_cubit.dart';

@immutable
abstract class CreateTaskState extends Equatable {}

class CreateTaskInitial extends CreateTaskState {
  @override
  List<Object?> get props => [];
}

class CreateTaskLoading extends CreateTaskState {
  @override
  List<Object?> get props => [];
}

class CreateTaskLoaded extends CreateTaskState {
  @override
  List<Object?> get props => [];
}

class CreateTaskError extends CreateTaskState {
  final String errorMessage;

  CreateTaskError({required this.errorMessage});

  @override
  List<Object?> get props => [this.errorMessage];
}
