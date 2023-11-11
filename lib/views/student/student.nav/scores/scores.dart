import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/repositories/quiz_repository.dart';
import 'package:mobile_reviewer/repositories/responses_repository.dart';
import 'package:mobile_reviewer/utils/constants.dart';

import '../../../../models/quiz.dart';
import '../../../../styles/pallete.dart';

class StudentScorePage extends StatelessWidget {
  const StudentScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizResponse>>(
      stream: context.read<QuizResponseRepository>().getScoreByStudentID(
          context.read<AuthRepository>().currentUser?.uid ?? ""),
      builder:
          (BuildContext context, AsyncSnapshot<List<QuizResponse>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data != null) {
          List<QuizResponse> responseList = snapshot.data ?? [];
          int count = responseList.length;
          return ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              QuizResponse response = snapshot.data![index];
              return ResponsesList(response: response);
            },
          );
        } else {
          return const Text('Unkown error.');
        }
      },
    );
  }
}

class ResponsesList extends StatelessWidget {
  final QuizResponse response;
  const ResponsesList({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz?>(
      future: context.read<QuizRepository>().getQuizByID(response.quizID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text("Loading..."),
            subtitle: Text("Loading..."),
          );
        } else if (snapshot.hasError) {
          return Card(
            child: ListTile(
              title: Text("${snapshot.error}"),
              subtitle: const Text("error"),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Card(
            child: ListTile(
              title: Text("No Quiz found!"),
              subtitle: Text("error"),
            ),
          );
        } else {
          Quiz? quiz = snapshot.data;
          return GestureDetector(
            onTap: () {
              context.push('/student/view-score', extra: {
                'quiz': jsonEncode(quiz!.toJson()),
                'response': jsonEncode(response.toJson()),
              });
            },
            child: Card(
              child: ListTile(
                dense: true,
                title: Text(
                  quiz?.title ?? "--no-quiz--",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "score : ${response.score} / ${getTotalPoints(quiz?.questions ?? [])}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
