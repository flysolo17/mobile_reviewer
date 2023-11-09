import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:mobile_reviewer/models/answers.dart';
import 'package:mobile_reviewer/models/questions.dart';
import 'package:mobile_reviewer/models/quiz.dart';

import 'package:mobile_reviewer/repositories/responses_repository.dart';
import 'package:mobile_reviewer/utils/constants.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';

import 'package:mobile_reviewer/widgets/button_primary.dart';
import 'package:uuid/uuid.dart';

import '../../../../../blocs/reponses/responses_bloc.dart';
import '../../../../../models/Responses.dart';
import '../../../../../repositories/auth_repository.dart';

List<Answer> _answerSheet = [];

class TakeQuizContainer extends StatelessWidget {
  final Quiz quiz;
  const TakeQuizContainer({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResponsesBloc(
        quizResponseRepository: context.read<QuizResponseRepository>(),
      ),
      child: TakeQuizPage(
          quiz: quiz), // Replace 'yourQuiz' with your actual Quiz object
    );
  }
}

class TakeQuizPage extends StatefulWidget {
  final Quiz quiz;
  const TakeQuizPage({super.key, required this.quiz});

  @override
  State<TakeQuizPage> createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  @override
  void dispose() {
    _answerSheet = [];
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the quiz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          children: [
            Image.network(
              widget.quiz.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${getTotalPoints(widget.quiz.questions)} Points',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quiz.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.quiz.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabQuestions(
                    questions: widget.quiz.questions,
                    onSubmit: () {
                      QuizResponse response = QuizResponse(
                          id: const Uuid().v4(),
                          quizID: widget.quiz.id,
                          studentID:
                              context.read<AuthRepository>().currentUser?.uid ??
                                  "",
                          answers: _answerSheet,
                          createdAt: DateTime.now(),
                          score: calculateTotalScore(
                              widget.quiz.questions, _answerSheet));
                      context
                          .read<ResponsesBloc>()
                          .add(AddResponseEvent(response));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TabQuestions extends StatefulWidget {
  final List<Questions> questions;
  final VoidCallback onSubmit;
  const TabQuestions(
      {super.key, required this.questions, required this.onSubmit});

  @override
  State<TabQuestions> createState() => _TabQuestionsState();
}

class _TabQuestionsState extends State<TabQuestions>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> tabViews = [];
  late int _selectedIndex = 0;

  static List<String> uniqueCategories(List<Quiz> quiz) {
    Set<String> uniqueCategories = Set<String>();
    for (var quizs in quiz) {
      uniqueCategories.add(quizs.category);
    }
    return uniqueCategories.toList();
  }

  @override
  void initState() {
    _tabController =
        TabController(length: widget.questions.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      }); // Update the state when the tab changes.
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void debugLayout() {
    debugDumpRenderTree();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: widget.questions
                .mapIndexed((index, question) => Tab(
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedIndex == index
                                ? Colors.green
                                : Colors.grey[100]),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("${index + 1}"),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.questions.map((question) {
                return QuestionInfo(questions: question, onTap: () {});
              }).toList(),
            ),
          ),
          BlocConsumer<ResponsesBloc, ResponsesState>(
            listener: (context, state) {
              if (state is QuizResponseErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is QuizResponseSuccessState<QuizResponse>) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Your Score is ${calculateTotalScore(widget.questions, _answerSheet)} out of ${getTotalPoints(widget.questions)}!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          ButtonPrimary(
                            onTap: () {
                              context.pop();
                              context.pop();
                              context.pop();
                            },
                            title: "Close",
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              return state is QuizResponseLoadingState
                  ? const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: OutlinedButtonPrimary(
                        title: "SUBMIT",
                        onTap: widget.onSubmit,
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}

class QuestionInfo extends StatelessWidget {
  final Questions questions;
  final VoidCallback onTap;
  const QuestionInfo({super.key, required this.questions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questions.question,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 20),
            ),
            Text(
              questions.description,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 14),
            ),
            ButtonGroup(
              choices: questions.choices,
              questions: questions,
            )
          ],
        ),
      ),
    );
  }
}

class ButtonGroup extends StatefulWidget {
  final List<String> choices;
  final Questions questions;
  ButtonGroup({super.key, required this.choices, required this.questions});

  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  int selectedButtonIndex = -1;

  void handleButtonTap(int index) {
    setState(() {
      selectedButtonIndex = index;
      addAnswer(widget.questions.id, widget.choices[index]);
    });
  }

  int indexOfQuestionID(List<Answer> answerList, String questionID) {
    for (int i = 0; i < answerList.length; i++) {
      if (answerList[i].questionID == questionID) {
        return i; // Return the index when a match is found
      }
    }
    return -1;
  }

  @override
  void initState() {
    int result = indexOfQuestionID(_answerSheet, widget.questions.id);
    if (result != -1) {
      setState(() {
        selectedButtonIndex = result;
      });
    }
    super.initState();
  }

  void addAnswer(String questionID, String ans) {
    int result = indexOfQuestionID(_answerSheet, questionID);
    if (result == -1) {
      _answerSheet.add(Answer(questionID: questionID, answer: ans));
    }
    _answerSheet[result].answer = ans;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.choices.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ElevatedButton(
            onPressed: () => handleButtonTap(index),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: selectedButtonIndex == index
                  ? Colors.green
                  : Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(widget.choices[index],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: selectedButtonIndex == index
                        ? Colors.white
                        : Colors.black,
                  )),
            ),
          ),
        );
      },
    );
  }
}
