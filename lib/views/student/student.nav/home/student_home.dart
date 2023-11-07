import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/repositories/quiz_repository.dart';
import 'package:mobile_reviewer/views/teacher/category/all_category.dart';
import 'package:mobile_reviewer/views/teacher/home/quiz/all_quiz.dart';
import 'package:mobile_reviewer/widgets/quiz_card.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            ClipRect(
              child: SizedBox(
                height: 200,
                child: AllCategoryPage(
                  maxCount: 4,
                ),
              ),
            ),
            const ListQuizies(),
          ],
        ),
      ),
    );
  }
}

class ListQuizies extends StatefulWidget {
  const ListQuizies({super.key});

  @override
  State<ListQuizies> createState() => _ListQuiziesState();
}

class _ListQuiziesState extends State<ListQuizies> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Quiz>>(
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Quizzies",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey[600]),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ListView.builder(
                  itemCount: count,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Quiz quiz = snapshot.data![index];
                    return QuizCard(
                      quiz: quiz,
                      onTap: () {
                        String encoded = jsonEncode(quiz);
                        context.push('/student/view-quiz',
                            extra: json.encode(quiz));
                      },
                    );
                  },
                ),
              ],
            );
          }
        } else {
          return const Text('Unkown error.');
        }
      },
    );
  }
}