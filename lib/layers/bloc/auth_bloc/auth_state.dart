part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoaded extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [this.error];
}
