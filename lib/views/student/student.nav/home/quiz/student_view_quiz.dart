import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/models/quiz.dart';

class StudentViewQuizPage extends StatelessWidget {
  final Quiz quiz;
  StudentViewQuizPage({super.key, required this.quiz});

  int getTotalPoints() {
    int total = 0;
    for (var e in quiz.questions) {
      total += e.points;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            quiz.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SvgPicture.asset(
                      'assets/svgs/quiz.svg',
                      height: 200,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 20.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  quiz.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFFEBE6FF)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.question_mark_sharp),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "${quiz.questions.length} Questions",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        const Icon(Icons.score_outlined),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "${getTotalPoints()} Points",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "DESCRIPTION",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                quiz.description,
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double
                                      .infinity, // Make the button width full width
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      context.go('/student/take-quiz',
                                          extra: jsonEncode(quiz.toJson()));
                                    },
                                    icon: const Icon(Icons
                                        .play_arrow_rounded), // Icon on the left
                                    label: const Text(
                                        'START QUIZ'), // Text on the right
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set border radius to 0
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
