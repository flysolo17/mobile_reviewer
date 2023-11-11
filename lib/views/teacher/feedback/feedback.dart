import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/reponses/responses_bloc.dart';
import 'package:mobile_reviewer/models/Responses.dart';
import 'package:mobile_reviewer/models/feedback.dart';
import 'package:mobile_reviewer/repositories/responses_repository.dart';
import '../../../models/quiz.dart';
import '../../../styles/pallete.dart';
import '../../../widgets/button_1.dart';

class TeacherFeedBackPage extends StatefulWidget {
  final Quiz quiz;
  final QuizResponse response;
  const TeacherFeedBackPage(
      {super.key, required this.quiz, required this.response});

  @override
  State<TeacherFeedBackPage> createState() => _TeacherFeedBackPageState();
}

class _TeacherFeedBackPageState extends State<TeacherFeedBackPage> {
  TextEditingController _feedbackController = TextEditingController();
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Feedback ",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: BlocProvider(
        create: (context) => ResponsesBloc(
            quizResponseRepository: context.read<QuizResponseRepository>()),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 100,
                height: 100,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Ratings for your Quiz Results!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  this.rating = rating;
                  print(rating);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _feedbackController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                  ),
                  maxLines: 4,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: BlocConsumer<ResponsesBloc, ResponsesState>(
                  listener: (context, state) {
                    if (state is QuizResponseErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    if (state is QuizResponseSuccessState<String>) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.data)));
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return state is QuizResponseLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ButtonPrimary(
                            title: "Send Feedback",
                            onTap: () {
                              final message = _feedbackController.text;
                              print(widget.response.id);
                              context.read<ResponsesBloc>().add(AddFeedBack(
                                  widget.response.id,
                                  TeacherFeedBack(
                                      stars: rating, message: message)));
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
