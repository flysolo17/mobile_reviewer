part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitialState extends UserState {}

final class UserLoadingState extends UserState {}

final class UserSuccessState<T> extends UserState {
  final T data;
  const UserSuccessState(this.data);
}

final class UserErrorState extends UserState {
  final String message;
  const UserErrorState(this.message);
  @override
  List<Object> get props => [message];
}
