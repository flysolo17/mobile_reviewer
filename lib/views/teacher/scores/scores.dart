import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/user/user_bloc.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';

import '../../../models/Responses.dart';
import '../../../models/quiz.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/quiz_repository.dart';
import '../../../repositories/responses_repository.dart';
import '../../../utils/constants.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizResponse>>(
      stream: context.read<QuizResponseRepository>().getScoreByTeacherID(
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
          return ResponseCard(quiz: quiz!, response: response);
        }
      },
    );
  }
}

class ResponseCard extends StatelessWidget {
  final Quiz quiz;
  final QuizResponse response;
  const ResponseCard({super.key, required this.quiz, required this.response});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: context.read<UserRepository>())
            ..add(GetUserByID(response.studentID)),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserErrorState) {
            return Card(
              child: ListTile(
                dense: true,
                leading: null,
                title: Text(
                  quiz.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "score : ${response.score} / ${getTotalPoints(quiz.questions ?? [])}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          } else if (state is UserLoadingState) {
            return const Card(
              child: ListTile(
                leading: null,
                dense: true,
                title: Text(
                  "Loading..",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Loading..",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          } else if (state is UserSuccessState<Users?>) {
            final Users? users = state.data;
            return GestureDetector(
                onTap: () {
                  context.push('/home/feedback', extra: {
                    'quiz': jsonEncode(quiz.toJson()),
                    'response': jsonEncode(response.toJson()),
                  });
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(
                              quiz.image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ListTile(
                            textColor: Colors.white,
                            title: Text(quiz.title),
                            subtitle: Text(
                              "score : ${response.score} / ${getTotalPoints(quiz?.questions ?? [])}",
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              users?.photo ?? "",
                            ),
                          ),
                          title: Text(users?.name ?? "no name"),
                          subtitle: Text(users?.email ?? "no email")),
                    ],
                  ),
                ));
          } else {
            print(state);
            return const Card(
              child: ListTile(
                dense: true,
                title: Text(
                  "User Not Found",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
