class Answer {
  final String questionID;
  String answer;

  Answer({
    required this.questionID,
    required this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionID: json['questionID'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionID': questionID,
      'answer': answer,
    };
  }
}
