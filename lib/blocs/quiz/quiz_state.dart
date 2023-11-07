part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

final class QuizInitial extends QuizState {}

final class QuizLoadingState extends QuizState {}

final class QuizSuccessState<T> extends QuizState {
  final T data;
  const QuizSuccessState(this.data);
}

final class QuizErrorState extends QuizState {
  final String message;
  const QuizErrorState(this.message);
  @override
  List<Object> get props => [message];
}
