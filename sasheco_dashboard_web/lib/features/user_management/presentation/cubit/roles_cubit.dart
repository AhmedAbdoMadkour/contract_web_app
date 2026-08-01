import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/role_model.dart';
import '../../data/repository/roles_repository.dart';

part 'roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  final RolesRepository _repository;

  RolesCubit(this._repository) : super(const RolesInitial());

  Future<void> fetchRoles() async {
    emit(const RolesLoading());
    final result = await _repository.fetchRoles();
    
    result.fold(
      (failure) => emit(RolesError(failure.message)),
      (roles) => emit(RolesLoaded(roles)),
    );
  }

  Future<void> updateRolePermissions(String roleId, List<String> newPermissions) async {
    final currentState = state;
    if (currentState is RolesLoaded) {
      emit(const RolesLoading());
      final result = await _repository.updateRolePermissions(roleId, newPermissions);
      
      result.fold(
        (failure) {
          emit(RolesError(failure.message));
          fetchRoles(); 
        },
        (_) {
          fetchRoles();
        },
      );
    }
  }
}
