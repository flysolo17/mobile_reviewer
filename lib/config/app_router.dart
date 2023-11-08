import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/models/Responses.dart';

import 'package:mobile_reviewer/models/quiz.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/views/auth/change_password.dart';
import 'package:mobile_reviewer/views/auth/forgot_password.dart';
import 'package:mobile_reviewer/views/auth/login.dart';
import 'package:mobile_reviewer/views/auth/sign_up.dart';
import 'package:mobile_reviewer/views/auth/start_page.dart';
import 'package:mobile_reviewer/views/profile/edit_profile.dart';
import 'package:mobile_reviewer/views/student/student.nav/developer/developer.dart';
import 'package:mobile_reviewer/views/student/student.nav/feedback/feedback.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/modules/lessons.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/modules/pdf_viewer.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/quiz/result.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/quiz/student_view_quiz.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/quiz/take_quiz.dart';

import 'package:mobile_reviewer/views/teacher/home/quiz/create_question.dart';
import 'package:mobile_reviewer/views/teacher/home/quiz/create_quiz.dart';
import 'package:mobile_reviewer/views/teacher/home/quiz/view_quiz.dart';
import 'package:mobile_reviewer/views/student/student_main.dart';

import 'package:mobile_reviewer/widgets/navigation.dart';

import '../views/student/student.nav/home/quiz/quiz.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const StarterPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) {
          return const ChangePasswordPage();
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          Users users = Users.fromJson(jsonDecode(state.extra.toString()));
          return EditProfilePage(users: users);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
          path: '/home',
          builder: (context, state) {
            return const MainNavigation();
          },
          routes: [
            GoRoute(
              path: 'create-quiz',
              builder: (context, state) {
                return CreateQuizPage();
              },
            ),
            GoRoute(
              path: 'view-quiz',
              builder: (context, state) {
                Quiz quiz = Quiz.fromJson(jsonDecode(state.extra.toString()));
                return ViewQuizPage(quiz: quiz);
              },
            ),
            GoRoute(
              path: 'create-question',
              builder: (context, state) {
                Quiz quiz = Quiz.fromJson(jsonDecode(state.extra.toString()));
                return CreateQuestionPage(quiz: quiz);
              },
            ),
          ]),
      GoRoute(
          path: '/student',
          builder: (context, state) {
            return const StudentMainPage();
          },
          routes: [
            GoRoute(
              path: 'lessons',
              builder: (context, state) {
                return const LessonsPage();
              },
            ),
            GoRoute(
              path: 'lessons/:path',
              builder: (BuildContext context, GoRouterState state) {
                return PdfViewer(path: state.pathParameters['path']!);
              },
            ),
            GoRoute(
              path: 'developer',
              builder: (context, state) {
                return const DeveloperPage();
              },
            ),
            GoRoute(
              path: 'feedback',
              builder: (context, state) {
                return const FeedBackPage();
              },
            ),
            GoRoute(
              path: 'quiz',
              builder: (context, state) {
                return StudentQuizPage();
              },
            ),
            GoRoute(
              path: 'view-quiz',
              builder: (context, state) {
                Quiz quiz = Quiz.fromJson(jsonDecode(state.extra.toString()));
                return StudentViewQuizPage(quiz: quiz);
              },
            ),
            GoRoute(
              path: 'take-quiz',
              builder: (context, state) {
                Quiz quiz = Quiz.fromJson(jsonDecode(state.extra.toString()));
                return TakeQuizContainer(quiz: quiz);
              },
            ),
            GoRoute(
              path: 'result',
              builder: (context, state) {
                Quiz quiz = Quiz.fromJson(
                    jsonDecode(state.pathParameters['quiz'].toString()));
                QuizResponse response = QuizResponse.fromJson(
                    jsonDecode(state.pathParameters['response'].toString()));
                return ResultPage(response: response, quiz: quiz);
              },
            ),
          ]),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   final authBloc = context.read<AuthBloc>();
    //   final authState = authBloc.state;
    //   // print(authState);
    //   // final bool matchedLocation = state.matchedLocation == '/login';
    //   // if (authState is UnAuthenticatedState) {
    //   //   return matchedLocation ? null : '/login';
    //   // }
    //   // if (matchedLocation) {
    //   //   if (authState is AuthenticatedState) {
    //   //     return "/home";
    //   //   }
    //   //   if (authState is UnAuthenticatedState) {
    //   //     return "/login";
    //   //   }
    //   // }
    //   return null;
    // },
  );
}
