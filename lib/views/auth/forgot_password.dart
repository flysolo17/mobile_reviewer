import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/blocs/auth/auth_bloc.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_primary.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Forgot Password",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: BlocProvider(
        create: (context) =>
            AuthBloc(authRepository: context.read<AuthRepository>()),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/svgs/forgot.svg',
                  height: 180,
                ),
              ),
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
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  print(state);
                  if (state is AuthErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is AuthSuccessState<String>) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.data)));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return state is AuthLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButtonPrimary(
                          title: "Forgot Password",
                          onTap: () {
                            String email = _emailController.text;
                            if (email.isNotEmpty) {
                              context
                                  .read<AuthBloc>()
                                  .add(ForgotPassword(email));
                            }
                          });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
