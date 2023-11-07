import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_reviewer/blocs/auth/auth_bloc.dart';
import 'package:mobile_reviewer/blocs/user/user_bloc.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';

import 'package:mobile_reviewer/widgets/secondary_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(userRepository: context.read<UserRepository>()),
      child: StreamBuilder<Users?>(
        stream: context
            .read<UserRepository>()
            .getUserByID(context.read<AuthRepository>().currentUser?.uid ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found.'));
          } else {
            Users user = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AccountContainer(user: user),
                const Spacer(),
                AccountActionsContainer(users: user),
              ],
            );
          }
        },
      ),
    );
  }
}

class AccountActionsContainer extends StatelessWidget {
  final Users users;
  const AccountActionsContainer({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SecondaryButton(
              title: "Edit Profile",
              onTap: () {
                context.push('/edit-profile', extra: jsonEncode(users));
              },
              icon: Icons.edit),
          const SizedBox(
            height: 10.0,
          ),
          SecondaryButton(
              title: "Change Password",
              onTap: () {
                context.push('/change-password');
              },
              icon: Icons.password_outlined),
          const SizedBox(
            height: 10.0,
          ),
          const LogoutButton(),
          const SizedBox(
            height: 10.0,
          ),
          const Text("EST 2023")
        ],
      ),
    );
  }
}

class AccountContainer extends StatelessWidget {
  final Users user;
  const AccountContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        UserProfileImage(
          imageUrl: user.photo,
          placeholderImage: "assets/images/person.png",
          userID: user.id,
        ),
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        Text(
          user.email,
        ),
        Text(user.userType.name),
      ]),
    );
  }
}

class UserProfileImage extends StatefulWidget {
  final String userID;
  final String? imageUrl;
  final String placeholderImage;
  const UserProfileImage(
      {super.key,
      required this.userID,
      this.imageUrl,
      required this.placeholderImage});
  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is UserSuccessState<String>) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.data)));
        }
      },
      builder: (context, state) {
        return state is UserLoadingState
            ? const Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    File file = File(image.path);
                    setState(() {
                      context
                          .read<UserBloc>()
                          .add(UploadUserPhoto(widget.userID, file));
                    });
                  } else {
                    print('create quiz page : error picking image');
                  }
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child:
                        widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                placeholder: widget.placeholderImage,
                                image: widget.imageUrl!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              )
                            : Image.asset(
                                widget.placeholderImage,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                  ),
                ),
              );
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthBloc(authRepository: context.read<AuthRepository>()),
      child: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticatedState) {
              context.go("/");
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const CircularProgressIndicator();
            } else {
              return SecondaryButton(
                  title: "Logout",
                  onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
                  icon: Icons.logout);
            }
          },
        ),
      ),
    );
  }
}
