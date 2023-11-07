import 'package:flutter/material.dart';

import 'package:mobile_reviewer/models/questions.dart';

import 'package:mobile_reviewer/widgets/question_card.dart';

class QuestionsPage extends StatelessWidget {
  final List<Questions> questions;
  QuestionsPage({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Questions question = questions[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: QuestionCard(
            questions: question,
          ),
        );
      },
    );
  }
}
