part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class CreateQuiz extends QuizEvent {
  final Quiz quiz;
  const CreateQuiz(this.quiz);
  @override
  List<Object?> get props => [quiz];
}

class CreateQuestion extends QuizEvent {
  final String quizID;
  final Questions questions;
  const CreateQuestion(this.quizID, this.questions);
  @override
  List<Object?> get props => [quizID, questions];
}

class UploadQuizBackground extends QuizEvent {
  final File file;
  final String userID;
  final String title;
  final String description;
  final String category;
  const UploadQuizBackground(
      this.file, this.userID, this.title, this.description, this.category);
  @override
  List<Object?> get props => [file, userID, title, description, category];
}
