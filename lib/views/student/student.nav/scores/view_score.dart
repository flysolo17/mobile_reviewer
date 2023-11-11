import 'package:flutter/material.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/styles/pallete.dart';

class ViewScorePage extends StatelessWidget {
  final Quiz quiz;
  final QuizResponse response;
  const ViewScorePage({super.key, required this.quiz, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(),
    );
  }
}
