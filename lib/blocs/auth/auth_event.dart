part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class UserChangedEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String name;

  final String email;
  final String password;
  const SignUpEvent(this.name, this.email, this.password);
  @override
  List<Object> get props => [name, email, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);
  @override
  List<Object?> get props => [email];
}

class LogoutEvent extends AuthEvent {}

class ReauthenticateUser extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  const ReauthenticateUser(this.currentPassword, this.newPassword);
  @override
  List<Object> get props => [currentPassword, newPassword];
}

class ChangeUserPassword extends AuthEvent {
  final User user;
  final String newPassword;
  const ChangeUserPassword(this.user, this.newPassword);
  @override
  List<Object> get props => [user, newPassword];
}
