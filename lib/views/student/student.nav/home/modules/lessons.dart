import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/styles/pallete.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modules"),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Modules",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  LessonGridItem(
                    image: 'assets/images/book1.png',
                    title: 'Social Welfare',
                    onTap: () {
                      context.push("/student/lessons/${"social_welfare.pdf"}");
                    },
                  ),
                  LessonGridItem(
                    image: 'assets/images/book2.png',
                    title: 'Social Services',
                    onTap: () {
                      context.push("/student/lessons/${"social_service.pdf"}");
                    },
                  ),
                  LessonGridItem(
                    image: 'assets/images/book3.png',
                    title: 'Social Work',
                    onTap: () {
                      context.push("/student/lessons/${"social_work.pdf"}");
                    },
                  ),
                  LessonGridItem(
                      image: 'assets/images/book4.png',
                      title: "Owwa",
                      onTap: () {
                        context.push("/student/lessons/${"owwa.pdf"}");
                      }),
                  LessonGridItem(
                      image: 'assets/images/book5.png',
                      title: "Test",
                      onTap: () {
                        context.push("/student/lessons/${"test.pdf"}");
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonGridItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  const LessonGridItem(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 130,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
