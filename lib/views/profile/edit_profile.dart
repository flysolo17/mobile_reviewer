import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_reviewer/blocs/user/user_bloc.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_primary.dart';

class EditProfilePage extends StatefulWidget {
  final Users users;
  const EditProfilePage({super.key, required this.users});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullnameController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.users.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: BlocProvider(
        create: (context) =>
            UserBloc(userRepository: context.read<UserRepository>()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 25.0,
              ),
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
              const Spacer(),
              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is UserSuccessState<String>) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.data)));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return state is UserLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButtonPrimary(
                          title: "Edit Profile",
                          onTap: () {
                            String name = _fullnameController.text;
                            context
                                .read<UserBloc>()
                                .add(ChangeFullname(widget.users.id, name));
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
