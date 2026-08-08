import 'package:equatable/equatable.dart';
import '../../data/model/user_model.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<UserModel> users;

  const UserManagementLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserManagementOperationSuccess extends UserManagementState {
  final String message;
  final List<UserModel> updatedUsers;

  const UserManagementOperationSuccess(this.message, this.updatedUsers);

  @override
  List<Object?> get props => [message, updatedUsers];
}
