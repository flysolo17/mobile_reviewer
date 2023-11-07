import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_reviewer/models/categories.dart';
import 'package:mobile_reviewer/repositories/category_repository.dart';
import 'package:mobile_reviewer/views/teacher/category/all_category.dart';
import 'package:mobile_reviewer/views/teacher/home/quiz/all_quiz.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 1, // Adjust the itemCount as needed
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const AllQuizPage(),
            ],
          );
        },
      ),
    );
  }
}
