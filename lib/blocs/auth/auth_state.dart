part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState<T> extends AuthState {
  final T data;
  const AuthSuccessState(this.data);
}

final class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);
  @override
  List<Object> get props => [message];
}

final class UnAuthenticatedState extends AuthState {}

final class AuthenticatedState extends AuthState {}
