import 'package:flutter/material.dart';

import 'package:mobile_reviewer/views/teacher/home/quiz/all_quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AllQuizPage();
  }
}
