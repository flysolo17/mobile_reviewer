part of 'responses_bloc.dart';

sealed class ResponsesState extends Equatable {
  const ResponsesState();

  @override
  List<Object> get props => [];
}

final class ResponsesInitial extends ResponsesState {}

final class QuizResponseLoadingState extends ResponsesState {}

final class QuizResponseSuccessState<T> extends ResponsesState {
  final T data;
  const QuizResponseSuccessState(this.data);
}

final class QuizResponseErrorState extends ResponsesState {
  final String message;
  const QuizResponseErrorState(this.message);
  @override
  List<Object> get props => [message];
}
