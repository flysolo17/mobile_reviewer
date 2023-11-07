import 'dart:ffi';

class Questions {
  String id;
  String question;
  String description;
  String answer;
  List<String> choices;
  int points;
  DateTime createdAt;
  Questions({
    required this.id,
    required this.question,
    required this.description,
    required this.answer,
    required this.choices,
    required this.points,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'description': description,
      'answer': answer,
      'choices': choices,
      'points': points,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      id: json['id'] as String,
      question: json['question'] as String,
      description: json['description'] as String,
      answer: json['answer'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((choice) => choice as String)
          .toList(),
      points: json['points'] ?? 0 as Int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
