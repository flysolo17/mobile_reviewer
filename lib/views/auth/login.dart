import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/auth/auth_bloc.dart';
import 'package:mobile_reviewer/blocs/user/user_bloc.dart';
import 'package:mobile_reviewer/models/user_type.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/widgets/button_primary.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>())
                  ..add(UserChangedEvent()),
          ),
          BlocProvider(
            create: (context) =>
                UserBloc(userRepository: context.read<UserRepository>()),
          ),
        ],
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is UserSuccessState<Users?>) {
              if (state.data != null) {
                if (state.data?.userType == UserType.TEACHER) {
                  context.go('/home');
                } else {
                  context.go('/student');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Successfully Logged in..")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not found")));
              }
            }
          },
          builder: (context, state) {
            return state is UserLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: 200,
                            height: 200,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          context.push('/forgot-password'),
                                      child: const Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          color:
                                              PrimaryColor, // Text color matching the border color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    if (state is AuthErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(state.message)));
                                    }
                                    if (state is AuthSuccessState<User>) {
                                      context
                                          .read<UserBloc>()
                                          .add(GetUserByID(state.data.uid));
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is AuthLoadingState) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return ButtonPrimary(
                                        title: "Login",
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var email = _emailController.text;
                                            var password =
                                                _passwordController.text;
                                            print('// ');
                                            context.read<AuthBloc>().add(
                                                SignInEvent(email, password));
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
