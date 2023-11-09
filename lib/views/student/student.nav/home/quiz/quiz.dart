import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/quiz.dart';
import '../../../../../repositories/quiz_repository.dart';
import '../../../../../styles/pallete.dart';
import '../../../../../widgets/quiz_card.dart';

class StudentQuizPage extends StatelessWidget {
  const StudentQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Quiz>>(
        stream: context.read<QuizRepository>().getAllQuiz(),
        builder: (BuildContext context, AsyncSnapshot<List<Quiz>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null) {
            List<Quiz> quizList = snapshot.data ?? [];
            context.read<QuizRepository>().setQuiz(quizList);
            int count = quizList.length;

            if (count == 0) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/no_data.png'),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text('No Quiz yet!'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  Quiz quiz = snapshot.data![index];
                  return QuizCard(
                    quiz: quiz,
                    onTap: () {
                      String encoded = jsonEncode(quiz);
                      context.push('/student/view-quiz', extra: encoded);
                    },
                  );
                },
              );
            }
          } else {
            return const Text('Unkown error.');
          }
        },
      ),
    );
  }
}
