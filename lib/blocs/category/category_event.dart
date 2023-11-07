part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CreateCategory extends CategoryEvent {
  final Categories categories;
  const CreateCategory(this.categories);
  @override
  List<Object?> get props => [categories];
}

class UploadCategoryBackground extends CategoryEvent {
  final File file;
  final String name;
  const UploadCategoryBackground(this.file, this.name);
  @override
  List<Object?> get props => [file, name];
}
