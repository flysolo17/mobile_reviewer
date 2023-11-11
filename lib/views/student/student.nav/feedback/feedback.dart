import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../blocs/user/user_bloc.dart';
import '../../../../models/Responses.dart';
import '../../../../models/quiz.dart';
import '../../../../models/users.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../repositories/quiz_repository.dart';
import '../../../../repositories/responses_repository.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../styles/pallete.dart';
import '../../../../utils/constants.dart';
import '../../../teacher/scores/scores.dart';

class FeedBackPage extends StatelessWidget {
  const FeedBackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: PrimaryBG,
          image: DecorationImage(
            image: AssetImage('assets/images/main_bg.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: StreamBuilder<List<QuizResponse>>(
          stream: context.read<QuizResponseRepository>().getFeedBack(
              context.read<AuthRepository>().currentUser?.uid ?? ""),
          builder: (BuildContext context,
              AsyncSnapshot<List<QuizResponse>> snapshot) {
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
                  return FeedBackList(response: response);
                },
              );
            } else {
              return const Text('Unkown error.');
            }
          },
        ),
      ),
    );
  }
}

class FeedBackList extends StatelessWidget {
  final QuizResponse response;
  const FeedBackList({super.key, required this.response});

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
          return FeedBackCard(quiz: quiz!, response: response);
        }
      },
    );
  }
}

class FeedBackCard extends StatelessWidget {
  final Quiz quiz;
  final QuizResponse response;
  const FeedBackCard({super.key, required this.quiz, required this.response});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: context.read<UserRepository>())
            ..add(GetUserByID(response.teacherID)),
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
            return Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(users!.photo),
                ),
                title: Text(users.name),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.feedback != null
                          ? response.feedback!.message
                          : "no feedback yet",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    RatingBar.builder(
                      initialRating: response.feedback != null
                          ? response.feedback!.stars.toDouble()
                          : 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
              ),
            );
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
