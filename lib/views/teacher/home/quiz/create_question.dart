import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/quiz/quiz_bloc.dart';
import 'package:mobile_reviewer/models/questions.dart';
import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/repositories/quiz_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';

List<String> choices = [];

class CreateQuestionPage extends StatelessWidget {
  Quiz quiz;
  CreateQuestionPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            "Create Question",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
          ),
          backgroundColor: PrimaryColor,
        ),
        body: BlocProvider(
          create: (context) =>
              QuizBloc(quizRepository: context.read<QuizRepository>()),
          child: SingleChildScrollView(
              child: QuestionForm(
            id: quiz.id,
          )),
        ));
  }
}

class QuestionForm extends StatefulWidget {
  String id;
  QuestionForm({super.key, required this.id});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  String question = "";
  String description = "";
  String answer = "";
  String points = "";
  @override
  void initState() {
    choices.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Question'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
              onChanged: (value) {
                question = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                description = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Answer'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an answer';
                }
                return null;
              },
              onChanged: (value) {
                answer = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Points'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter points';
                }
                return null;
              },
              onChanged: (value) {
                points = value;
              },
            ),
            const Choices(),
            const SizedBox(height: 16.0),
            BlocConsumer<QuizBloc, QuizState>(
              listener: (context, state) {
                if (state is QuizErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is QuizSuccessState<String>) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.data)));
                  context.pop();
                }
              },
              builder: (context, state) {
                return state is QuizLoadingState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ButtonPrimary(
                        title: "Save Question",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Questions questions = Questions(
                                id: '',
                                question: question,
                                description: description,
                                answer: answer,
                                choices: choices,
                                points: int.tryParse(points) ?? 0,
                                createdAt: DateTime.now());
                            context
                                .read<QuizBloc>()
                                .add(CreateQuestion(widget.id, questions));
                          }
                        });
              },
            )
          ],
        ),
      ),
    );
  }
}

class Choices extends StatefulWidget {
  const Choices({super.key});

  @override
  State<Choices> createState() => _ChoicesState();
}

class _ChoicesState extends State<Choices> {
  final TextEditingController _textEditingController = TextEditingController();

  void _addChoice(String choice) {
    setState(() {
      choices.add(choice);
    });
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Enter a choice',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                String choice = _textEditingController.text;
                if (choice.isNotEmpty) {
                  print(choice);
                  _addChoice(_textEditingController.text);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.map((choice) {
              return Text(choice);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
