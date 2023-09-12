import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/views/auth/login.dart';
import 'package:mobile_reviewer/views/auth/sign_up.dart';
import 'package:mobile_reviewer/views/home/home.dart';
import 'package:mobile_reviewer/widgets/navigation.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const MainNavigation();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const SignUpPage();
        },
      ),
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
