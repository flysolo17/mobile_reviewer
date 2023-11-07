import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/auth/auth_bloc.dart';
import 'package:mobile_reviewer/blocs/user/user_bloc.dart';
import 'package:mobile_reviewer/models/user_type.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedRole = 'STUDENT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Create account",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>()),
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
              if (state is UserSuccessState<Users>) {
                if (state.data.userType == UserType.TEACHER) {
                  context.go('/home');
                } else {
                  context.go('/student');
                }
              }
            },
            builder: (context, state) {
              if (state is UserLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  labelText: 'Fullname',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your fullname';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                decoration: InputDecoration(
                                  labelText: 'I am a',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedRole = newValue!;
                                  });
                                },
                                items: <String>['STUDENT', 'TEACHER']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.message)));
                                  }
                                  if (state is AuthSuccessState<Users>) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Successfully signed up'),
                                      ),
                                    );
                                    context
                                        .read<UserBloc>()
                                        .add(CreateUser(state.data));
                                  }
                                },
                                builder: (context, state) {
                                  return state is AuthLoadingState
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ButtonPrimary(
                                          title: "Sign Up",
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              String name =
                                                  _fullnameController.text;
                                              String email =
                                                  _emailController.text;
                                              String password =
                                                  _passwordController.text;
                                              UserType type =
                                                  selectedRole == 'STUDENT'
                                                      ? UserType.STUDENT
                                                      : UserType.TEACHER;
                                              context.read<AuthBloc>().add(
                                                    SignUpEvent(name, email,
                                                        password, type),
                                                  );
                                            }
                                          },
                                        );
                                },
                              ),
                              TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text(
                                      "Already Have an account ? Sign In"))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
