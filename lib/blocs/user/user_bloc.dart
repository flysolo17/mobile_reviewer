import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_reviewer/blocs/auth/auth_bloc.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitialState()) {
    on<UserEvent>((event, emit) {});
    on<CreateUser>(_createUser);
    on<UpdateUserInfo>(_updateUserInfo);
    on<UploadUserPhoto>(_uploadUserProfile);
    on<UpdateUserPhoto>(_updateUserPhoto);
    on<GetUserByID>(_getUserByID);
    on<ChangeFullname>(_onChangeFullname);
  }

  Future<void> _createUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await _userRepository.addUser(event.users);
      emit(UserSuccessState<Users>(event.users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
      emit(UserInitialState());
    }
  }

  Future<void> _updateUserInfo(
      UpdateUserInfo event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await _userRepository.updateUserProfile(event.users);
      emit(const UserSuccessState<String>("Successfully Updated"));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _uploadUserProfile(
      UploadUserPhoto event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      String? result = await _userRepository.uploadFile(event.image);
      await Future.delayed(const Duration(seconds: 1));
      if (result != null) {
        add(UpdateUserPhoto(event.userID, result));
      } else {
        emit(const UserErrorState("Error uploading image"));
        emit(UserInitialState());
      }
    } catch (e) {
      emit(UserErrorState(e.toString()));
      emit(UserInitialState());
    }
  }

  Future<void> _updateUserPhoto(
      UpdateUserPhoto event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      await _userRepository.updateUserPhoto(event.userID, event.imageURL);
      emit(const UserSuccessState<String>("Profile Successfully updated"));
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    } finally {
      emit(UserInitialState());
    }
  }

  Future<void> _getUserByID(GetUserByID event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      Users? result = await _userRepository.getUserInfo(event.userID);
      emit(UserSuccessState<Users?>(result));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onChangeFullname(
      ChangeFullname event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      await _userRepository.updateUserFullname(event.userID, event.fullname);
      emit(const UserSuccessState<String>("Fullname successfully Changed!"));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
