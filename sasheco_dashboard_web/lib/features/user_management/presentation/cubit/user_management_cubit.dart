import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/user_management_repository.dart';
import '../../data/model/user_model.dart';
import 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserManagementRepository _repository;
  List<UserModel> _currentUsers = [];

  UserManagementCubit(this._repository) : super(UserManagementInitial());

  Future<void> loadUsers() async {
    emit(UserManagementLoading());
    final result = await _repository.getUsers();
    
    result.fold(
      (failure) => emit(UserManagementError(failure.message)),
      (users) {
        for (var i = 0; i < users.length; i++) {
          final existingIdx = _currentUsers.indexWhere((u) => 
            u.id == users[i].id || 
            (u.email.isNotEmpty && u.email.toLowerCase() == users[i].email.toLowerCase()) ||
            (u.name.isNotEmpty && u.name.toLowerCase() == users[i].name.toLowerCase())
          );
          if (existingIdx != -1 && _currentUsers[existingIdx].avatarBytes != null) {
            users[i] = users[i].copyWith(avatarBytes: _currentUsers[existingIdx].avatarBytes);
          }
        }
        _currentUsers = users;
        emit(UserManagementLoaded(users));
      },
    );
  }

  Future<void> createUser(UserModel user) async {
    emit(UserManagementLoading());
    final result = await _repository.createUser(user);
    
    result.fold(
      (failure) {
        emit(UserManagementError(failure.message));
        emit(UserManagementLoaded(_currentUsers)); // Restore previous state
      },
      (newUser) {
        if (user.avatarBytes != null) {
          newUser = newUser.copyWith(avatarBytes: user.avatarBytes);
        }
        _currentUsers = List.from(_currentUsers)..add(newUser);
        emit(UserManagementOperationSuccess('User created successfully.', _currentUsers));
        emit(UserManagementLoaded(_currentUsers));
      },
    );
  }

  Future<void> updateUser(UserModel user) async {
    emit(UserManagementLoading());
    final result = await _repository.updateUser(user);
    
    result.fold(
      (failure) {
        emit(UserManagementError(failure.message));
        emit(UserManagementLoaded(_currentUsers)); // Restore previous state
      },
      (updatedUser) {
        final index = _currentUsers.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _currentUsers = List.from(_currentUsers)..[index] = updatedUser;
        }
        emit(UserManagementOperationSuccess('User updated successfully.', _currentUsers));
        emit(UserManagementLoaded(_currentUsers));
      },
    );
  }

  Future<void> deleteUser(String id) async {
    emit(UserManagementLoading());
    final result = await _repository.deleteUser(id);
    
    result.fold(
      (failure) {
        emit(UserManagementError(failure.message));
        emit(UserManagementLoaded(_currentUsers)); // Restore previous state
      },
      (_) {
        _currentUsers = List.from(_currentUsers)..removeWhere((u) => u.id == id);
        emit(UserManagementOperationSuccess('User deleted successfully.', _currentUsers));
        emit(UserManagementLoaded(_currentUsers));
      },
    );
  }
}
