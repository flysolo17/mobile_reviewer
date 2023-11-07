import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_reviewer/models/categories.dart';
import 'package:mobile_reviewer/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {});
    on<CreateCategory>(_onCreateCategory);
    on<UploadCategoryBackground>(_onUploadBackground);
  }

  Future<void> _onCreateCategory(
      CreateCategory event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());
      await _categoryRepository.addCategory(event.categories);
      await Future.delayed(const Duration(seconds: 1));
      emit(const CategorySuccessState<String>("Successfully Added"));
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    } finally {
      emit(CategoryInitial());
    }
  }

  Future<void> _onUploadBackground(
      UploadCategoryBackground event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());
      String? result = await _categoryRepository.uploadFile(event.file);
      if (result != null) {
        Categories categories = Categories(
            id: '',
            category: event.name,
            image: result,
            createdAt: DateTime.now());
        add(CreateCategory(categories));
      } else {
        emit(const CategoryErrorState("Failed uploading file"));
        emit(CategoryInitial());
      }
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
      emit(CategoryInitial());
    }
  }
}
