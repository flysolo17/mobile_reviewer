import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../styles/pallete.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 90,
                height: 90,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Social Work Reviewer",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: TextPrimary),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: TextPrimary),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: <Widget>[
              GridItem(
                value: 'Modules / Lessons',
                onTap: () {
                  context.push("/student/lessons");
                },
                imageUrl: 'assets/images/lessons.png',
              ),
              GridItem(
                value: 'Quiz',
                onTap: () => context.push('/student/quiz'),
                imageUrl: 'assets/images/quiz.png',
              ),
              GridItem(
                value: 'Developer',
                onTap: () => context.push('/student/developer'),
                imageUrl: 'assets/images/developer.png',
              ),
              GridItem(
                value: 'Feedback',
                onTap: () => context.push('/student/feedback'),
                imageUrl: 'assets/images/feedback.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String value;
  VoidCallback onTap;
  final String imageUrl;
  GridItem({required this.value, required this.onTap, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CardBG,
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imageUrl,
                width: 70,
                height: 70,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}



// class ListQuizies extends StatefulWidget {
//   const ListQuizies({super.key});

//   @override
//   State<ListQuizies> createState() => _ListQuiziesState();
// }

// class _ListQuiziesState extends State<ListQuizies> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Quiz>>(
//       stream: context.read<QuizRepository>().getAllQuiz(),
//       builder: (BuildContext context, AsyncSnapshot<List<Quiz>> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (snapshot.data != null) {
//           List<Quiz> quizList = snapshot.data ?? [];

//           int count = quizList.length;

//           if (count == 0) {
//             return Container(
//               height: 200,
//               decoration: BoxDecoration(
//                   image: const DecorationImage(
//                     image: AssetImage('assets/images/no_data.png'),
//                     fit: BoxFit.fitHeight,
//                   ),
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Center(
//                 child: Text('No Quiz yet!'),
//               ),
//             );
//           } else {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Your Quizzies",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       color: Colors.grey[600]),
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 ListView.builder(
//                   itemCount: count,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     Quiz quiz = snapshot.data![index];
//                     return QuizCard(
//                       quiz: quiz,
//                       onTap: () {
//                         String encoded = jsonEncode(quiz);
//                         context.push('/student/view-quiz',
//                             extra: json.encode(quiz));
//                       },
//                     );
//                   },
//                 ),
//               ],
//             );
//           }
//         } else {
//           return const Text('Unkown error.');
//         }
//       },
//     );
//   }
// }
