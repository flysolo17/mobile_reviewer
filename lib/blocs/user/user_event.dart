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

class UploadUserPhoto extends UserEvent {
  final String userID;
  final File image;
  const UploadUserPhoto(this.userID, this.image);
  @override
  List<Object?> get props => [userID, image];
}

class UpdateUserPhoto extends UserEvent {
  final String userID;
  final String imageURL;
  const UpdateUserPhoto(this.userID, this.imageURL);
  @override
  List<Object?> get props => [userID, imageURL];
}

class GetUserByID extends UserEvent {
  final String userID;
  const GetUserByID(this.userID);
  @override
  List<Object?> get props => [userID];
}

class ChangeFullname extends UserEvent {
  final String userID;
  final String fullname;
  const ChangeFullname(this.userID, this.fullname);
  @override
  List<Object> get props => [userID, fullname];
}
