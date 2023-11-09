import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/repositories/responses_repository.dart';

part 'responses_event.dart';
part 'responses_state.dart';

class ResponsesBloc extends Bloc<ResponsesEvent, ResponsesState> {
  final QuizResponseRepository _quizResponseRepository;
  ResponsesBloc({required QuizResponseRepository quizResponseRepository})
      : _quizResponseRepository = quizResponseRepository,
        super(ResponsesInitial()) {
    on<ResponsesEvent>((event, emit) {});
    on<AddResponseEvent>(_onAddResponseEvent);
  }

  Future<void> _onAddResponseEvent(
      AddResponseEvent event, Emitter<ResponsesState> emit) async {
    try {
      emit(QuizResponseLoadingState());
      await _quizResponseRepository.addQuizResponse(event.response);
      await Future.delayed(const Duration(seconds: 1));
      emit(QuizResponseSuccessState<QuizResponse>(event.response));
    } catch (e) {
      emit(QuizResponseErrorState(e.toString()));
    } finally {
      emit(ResponsesInitial());
    }
  }

  // Future<void> _onGetScoreByStudentID(
  //     GetScoreByStudentID event, Emitter<ResponsesState> emit) async {
  //   try {
  //     emit(QuizResponseLoadingState());
  //     List<QuizResponse> result = await _quizResponseRepository.getScoreByStudentID(event.uid);
  //     await Future.delayed(const Duration(seconds: 1));
  //     emit(QuizResponseSuccessState<List<QuizResponse>>(result));
  //   } catch (e) {
  //     emit(QuizResponseErrorState(e.toString()));
  //   } finally {
  //     emit(ResponsesInitial());
  //   }
  // }
}
