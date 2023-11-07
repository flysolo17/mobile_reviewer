import 'package:flutter/material.dart';
import 'package:mobile_reviewer/models/questions.dart';

class QuestionCard extends StatelessWidget {
  final Questions questions;
  QuestionCard({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questions.question,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12),
              ),
            ),
            Text(
              questions.description,
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "Choices",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12),
              ),
            ),
            ChoicesList(choices: questions.choices),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Answer: ${questions.answer}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoicesList extends StatelessWidget {
  final List<String> choices;
  ChoicesList({required this.choices});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, // Set shrinkWrap to true
      itemCount: choices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(choices[index]),
            ),
          ),
        );
      },
    );
  }
}
