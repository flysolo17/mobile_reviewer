import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_reviewer/blocs/category/category_bloc.dart';
import 'package:mobile_reviewer/blocs/quiz/quiz_bloc.dart';
import 'package:mobile_reviewer/models/categories.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';
import 'package:mobile_reviewer/repositories/category_repository.dart';
import 'package:mobile_reviewer/repositories/quiz_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';

class CreateQuizPage extends StatefulWidget {
  CreateQuizPage({super.key});
  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  int _selectedCategory = 0;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _selectedImage;
  @override
  Widget build(BuildContext context) {
    List<Categories> categories =
        context.read<CategoryRepository>().getCategories();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Create Quiz",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: BlocProvider(
        create: (context) =>
            QuizBloc(quizRepository: context.read<QuizRepository>()),
        child: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is QuizSuccessState<String>) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.data)));
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is QuizLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _selectedImage = image.path;
                            });
                            print("selected");
                          } else {
                            print('create quiz page : error picking image');
                          }
                        },
                        child: _selectedImage != null
                            ? Image.file(
                                File(_selectedImage!),
                                width: 200,
                                height: 200,
                              )
                            : Image.asset(
                                "assets/images/placeholder.png",
                                width: 200,
                                height: 200,
                              ),
                      ),
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category / Topic',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: categories.asMap().entries.map((entry) {
                        int index = entry.key;
                        Categories value = entry.value;
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text(value.category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonPrimary(
                      onTap: () {
                        String title = _titleController.text;
                        String description = _descriptionController.text;
                        String category = categories[_selectedCategory].id;
                        if (_selectedImage != null &&
                            title.isNotEmpty &&
                            description.isNotEmpty &&
                            category.isNotEmpty) {
                          File file = File(_selectedImage!);
                          User? user =
                              context.read<AuthRepository>().currentUser;
                          if (user != null) {
                            context.read<QuizBloc>().add(UploadQuizBackground(
                                file, user.uid, title, description, category));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error no user found!'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill up all forms'),
                            ),
                          );
                        }
                      },
                      title: "Save",
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
