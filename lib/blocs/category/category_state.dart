part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoadingState extends CategoryState {}

final class CategorySuccessState<T> extends CategoryState {
  final T data;
  const CategorySuccessState(this.data);
}

final class CategoryErrorState extends CategoryState {
  final String message;
  const CategoryErrorState(this.message);
  @override
  List<Object> get props => [message];
}
