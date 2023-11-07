import 'package:mobile_reviewer/models/answers.dart';

class QuizResponse {
  final String id;
  final String quizID;
  final String studentID;
  final List<Answer> answers;
  final int score;
  final DateTime createdAt;

  QuizResponse({
    required this.id,
    required this.quizID,
    required this.studentID,
    required this.answers,
    required this.score,
    required this.createdAt,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> answerList = json['answers'];
    List<Answer> answers = answerList.map((answerJson) {
      return Answer.fromJson(answerJson);
    }).toList();

    return QuizResponse(
      id: json['id'],
      quizID: json['quizID'],
      studentID: json['studentID'],
      answers: answers,
      score: json['score'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> answerJsonList = answers.map((answer) {
      return answer.toJson();
    }).toList();

    return {
      'id': id,
      'quizID': quizID,
      'studentID': studentID,
      'answers': answerJsonList,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'QuizResponse{id: $id, quizID: $quizID, studentID: $studentID, answers: $answers, createdAt: $createdAt}';
  }
}
