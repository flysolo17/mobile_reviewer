import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_reviewer/blocs/category/category_bloc.dart';
import 'package:mobile_reviewer/repositories/category_repository.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/widgets/button_1.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _categoryName = TextEditingController();
  String? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Create Category",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: BlocProvider(
        create: (context) => CategoryBloc(
            categoryRepository: context.read<CategoryRepository>()),
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is CategorySuccessState<String>) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.data)));
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is CategoryLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        print("Image picker clicked");
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _selectedImage = image.path;
                          });
                          print("selected");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error picking image'),
                            ),
                          );
                        }
                      },
                      child: _selectedImage != null
                          ? Image.file(
                              File(
                                  _selectedImage!), // Use FileImage with the selected image path
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _categoryName,
                      decoration: InputDecoration(
                        labelText: 'Category/ Topic',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ButtonPrimary(
                      onTap: () {
                        if (_selectedImage != null) {
                          File file = File(_selectedImage!);
                          String name = _categoryName.text.toString();
                          context
                              .read<CategoryBloc>()
                              .add(UploadCategoryBackground(file, name));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill up all forms'),
                            ),
                          );
                        }
                      },
                      title: "Save",
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
