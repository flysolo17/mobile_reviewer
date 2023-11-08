import 'package:mobile_reviewer/models/questions.dart';

class Quiz {
  String id;
  final String userID;
  final String image;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  final List<Questions> questions;

  Quiz({
    required this.id,
    required this.userID,
    required this.image,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'image': image,
      'title': title,
      'description': description,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      userID: json['userID'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      questions: (json['questions'] as List<dynamic>)
          .map((questionJson) => Questions.fromJson(questionJson))
          .toList(),
    );
  }
}
