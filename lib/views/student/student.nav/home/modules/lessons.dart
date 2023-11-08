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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 90,
              height: 90,
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
              children: <Widget>[
                LessonGridItem(
                  title: 'Social Welfare',
                  onTap: () {
                    context.push("/student/lessons/${"social_welfare.pdf"}");
                  },
                ),
                LessonGridItem(
                  title: 'Social Services',
                  onTap: () {
                    context.push("/student/lessons/${"social_service.pdf"}");
                  },
                ),
                LessonGridItem(
                  title: 'Social Work',
                  onTap: () {
                    context.push("/student/lessons/${"social_work.pdf"}");
                  },
                ),
                LessonGridItem(
                    title: "Owwa",
                    onTap: () {
                      context.push("/student/lessons/${"owwa.pdf"}");
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LessonGridItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const LessonGridItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folder.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
