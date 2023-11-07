import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_reviewer/models/user_type.dart';
import 'package:mobile_reviewer/models/users.dart';
import 'package:mobile_reviewer/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<SignInEvent>(_signIn);
    on<UserChangedEvent>(_onUserChange);
    on<LogoutEvent>(_authLoggedOutEvent);
    on<SignUpEvent>(_signUpEvent);
    on<ForgotPassword>(_forgotPassword);
    on<ReauthenticateUser>(_onReauthenticateUser);
    on<ChangeUserPassword>(_onChangePassword);
  }

  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      var result = await _authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      await Future.delayed(const Duration(seconds: 1));
      if (result != null) {
        emit(AuthSuccessState<User>(result));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      var result = await _authRepository.registerWithEmailAndPassword(
          email: event.email, password: event.password);
      Users users = Users(
          id: result!.uid,
          name: event.name,
          photo: '',
          email: event.email,
          userType: event.userType);
      emit(AuthSuccessState<Users>(users));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onUserChange(
      UserChangedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final User? currentUser = _authRepository.currentUser;
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) {
      emit(AuthSuccessState<User>(currentUser));
    } else {
      emit(UnAuthenticatedState());
    }
  }

  void _authLoggedOutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      print("Signing out");
      await _authRepository.signOut();
      emit(UnAuthenticatedState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _forgotPassword(
      ForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authRepository.resetPassword(event.email);
      emit(AuthSuccessState<String>("We've sent an email to ${event.email}"));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onChangePassword(
      ChangeUserPassword event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authRepository.changePassword(event.user, event.newPassword);
      emit(const AuthSuccessState<String>("Password changed successfully!"));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(AuthInitial());
    }
  }

  Future<void> _onReauthenticateUser(
      ReauthenticateUser event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      User user = await _authRepository.reAuthenticateUser(
          _authRepository.currentUser!, event.currentPassword);
      await Future.delayed(const Duration(seconds: 1));
      add(ChangeUserPassword(user, event.newPassword));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(AuthInitial());
    }
  }
}
