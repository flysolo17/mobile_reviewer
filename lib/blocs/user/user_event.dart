part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class CreateUser extends UserEvent {
  final Users users;
  const CreateUser(this.users);
  @override
  List<Object?> get props => [users];
}

class GetUserProfile extends UserEvent {
  final String userID;
  const GetUserProfile(this.userID);
  @override
  List<Object?> get props => [userID];
}

class UpdateUserInfo extends UserEvent {
  final Users users;
  const UpdateUserInfo(this.users);
  @override
  List<Object?> get props => [users];
}
