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
          bool isScoreHighEnough(double score) {
            double totalPossible = snapshot.data!.questions.fold(
              0.0, // Initial value
              (double sum, dynamic question) => sum + question.points,
            );
            if (totalPossible <= 0) {
              throw ArgumentError(
                  "Score and total possible score must be valid numbers.");
            }

            final percentage = score / totalPossible * 100;
            return percentage >= 75;
          }

          return GestureDetector(
            onTap: () {
              context.push('/student/view-score', extra: {
                'quiz': jsonEncode(quiz!.toJson()),
                'response': jsonEncode(response.toJson()),
              });
            },
            child: Card(
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
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
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: isScoreHighEnough(response.score.toDouble())
                              ? Colors.green
                              : Colors.red),
                      child: Text(
                        isScoreHighEnough(response.score.toDouble())
                            ? "You did great!"
                            : "Better luck next time.",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
