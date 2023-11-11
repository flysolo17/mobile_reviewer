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

class GetScoreByStudentID extends ResponsesEvent {
  final String uid;
  const GetScoreByStudentID(this.uid);
  @override
  List<Object> get props => [uid];
}

class AddFeedBack extends ResponsesEvent {
  final String responseID;
  final TeacherFeedBack feedback;
  const AddFeedBack(this.responseID, this.feedback);
  @override
  List<Object> get props => [responseID, feedback];
}
