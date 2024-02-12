part of 'category_cubit.dart';

@immutable
abstract class CategoryState extends Equatable {}

class CategoryInitial extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoaded extends CategoryState {
  List<Category> categories;

  CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [this.categories];
}

class CategoryError extends CategoryState {
  final String errorMessage;

  CategoryError({required this.errorMessage});

  @override
  List<Object?> get props => [this.errorMessage];
}
