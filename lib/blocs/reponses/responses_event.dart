part of 'responses_bloc.dart';

sealed class ResponsesEvent extends Equatable {
  const ResponsesEvent();

  @override
  List<Object> get props => [];
}

class AddResponseEvent extends ResponsesEvent {
  final QuizResponse response;
  const AddResponseEvent(this.response);
  @override
  List<Object> get props => [response];
}
