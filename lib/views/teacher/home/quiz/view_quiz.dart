import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/views/teacher/home/quiz/questions.dart';

class ViewQuizPage extends StatelessWidget {
  Quiz quiz;
  ViewQuizPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [QuizActions(quiz: quiz)],
        title: Text(
          quiz.title,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(quiz.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        quiz.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              QuestionsPage(questions: quiz.questions),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PopMenuValues {
  edit,
  delete,
  question,
}

class QuizActions extends StatelessWidget {
  final Quiz quiz;
  QuizActions({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    void _handleMenuSelection(_PopMenuValues choice) {
      // Handle the selected menu item here
      switch (choice) {
        case _PopMenuValues.edit:
          // Handle edit
          break;
        case _PopMenuValues.delete:
          // Handle delete
          break;
        case _PopMenuValues.question:
          context.push('/home/create-question', extra: json.encode(quiz));
          break;
      }
    }

    return PopupMenuButton<_PopMenuValues>(
      onSelected: _handleMenuSelection,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _PopMenuValues.edit,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: _PopMenuValues.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete'),
          ),
        ),
        PopupMenuItem(
          value: _PopMenuValues.question,
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Add Question'),
          ),
        ),
      ],
    );
  }
}
