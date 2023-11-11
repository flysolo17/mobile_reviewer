import 'package:mobile_reviewer/models/answers.dart';
import 'package:mobile_reviewer/models/feedback.dart';

class QuizResponse {
  final String id;
  final String quizID;
  final String teacherID;
  final String studentID;
  final List<Answer> answers;
  final int score;
  final TeacherFeedBack? feedback;
  final DateTime createdAt;

  QuizResponse({
    required this.id,
    required this.quizID,
    required this.teacherID,
    required this.studentID,
    required this.answers,
    required this.score,
    this.feedback,
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
      teacherID: json['teacherID'],
      studentID: json['studentID'],
      answers: answers,
      score: json['score'],
      feedback: json['feedback'] != null
          ? TeacherFeedBack.fromJson(json['feedback'])
          : null,
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
      'teacherID': teacherID,
      'studentID': studentID,
      'answers': answerJsonList,
      'score': score,
      'feedback': feedback?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'QuizResponse{id: $id, quizID: $quizID, studentID: $studentID, answers: $answers, createdAt: $createdAt}';
  }
}
