import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_reviewer/models/questions.dart';
import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/repositories/quiz_repository.dart';
part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;
  QuizBloc({required QuizRepository quizRepository})
      : _quizRepository = quizRepository,
        super(QuizInitial()) {
    on<QuizEvent>((event, emit) {});
    on<CreateQuiz>(_onCreateQuiz);
    on<UploadQuizBackground>(_onUploadBackground);
    on<CreateQuestion>(_onCreateQuestion);
  }

  Future<void> _onCreateQuiz(CreateQuiz event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoadingState());
      await _quizRepository.addQuiz(event.quiz);
      await Future.delayed(const Duration(seconds: 1));
      emit(const QuizSuccessState<String>("Successfully Added"));
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    } finally {
      emit(QuizInitial());
    }
  }

  Future<void> _onUploadBackground(
      UploadQuizBackground event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoadingState());
      String? result = await _quizRepository.uploadFile(event.file);
      if (result != null) {
        Quiz quiz = Quiz(
            id: '',
            userID: event.userID,
            image: result,
            title: event.title,
            description: event.description,
            category: event.category,
            createdAt: DateTime.now(),
            questions: []);
        add(CreateQuiz(quiz));
      } else {
        emit(const QuizErrorState("Failed uploading file"));
        emit(QuizInitial());
      }
    } catch (e) {
      emit(QuizErrorState(e.toString()));
      emit(QuizInitial());
    }
  }

  Future<void> _onCreateQuestion(
      CreateQuestion event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoadingState());
      await _quizRepository.addQuestion(event.quizID, event.questions);
      await Future.delayed(const Duration(seconds: 1));
      emit(const QuizSuccessState<String>("Question Successfully Added!"));
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    } finally {
      emit(QuizInitial());
    }
  }
}
