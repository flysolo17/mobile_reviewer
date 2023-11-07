import 'package:flutter/material.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/models/quiz.dart';

import '../../../../../styles/pallete.dart';
import '../../../../../utils/constants.dart';

class ResultPage extends StatelessWidget {
  final QuizResponse response;
  final Quiz quiz;
  const ResultPage({super.key, required this.response, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Result",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: Column(
        children: [
          const Text("Score"),
          Text("${response.score}/${getTotalPoints(quiz.questions)}"),
        ],
      ),
    );
  }
}
