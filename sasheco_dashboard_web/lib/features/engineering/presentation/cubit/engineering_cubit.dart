import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/engineering_repository.dart';
import 'engineering_state.dart';

class EngineeringCubit extends Cubit<EngineeringState> {
  final EngineeringRepository _repository;

  EngineeringCubit(this._repository) : super(EngineeringInitial());

  Future<void> fetchProjects() async {
    emit(EngineeringLoading());
    final result = await _repository.getProjects();
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (projects) => emit(EngineeringProjectsLoaded(projects)),
    );
  }

  Future<void> fetchProject(String id) async {
    emit(EngineeringLoading());
    final result = await _repository.getProject(id);
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (project) => emit(EngineeringProjectLoaded(project)),
    );
  }

  Future<void> createProject({
    required String name,
    required String description,
    required DateTime startDate,
  }) async {
    emit(EngineeringLoading());
    final result = await _repository.createProject(
      name: name,
      description: description,
      startDate: startDate,
    );
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (project) => emit(EngineeringProjectCreated(project)),
    );
  }
  Future<void> updateProjectStatus(String id, String status) async {
    emit(EngineeringLoading());
    final result = await _repository.updateProjectStatus(id, status);
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (_) {
        emit(EngineeringStatusUpdated(id: id, status: status));
        // Optionally refetch projects to update the list
        fetchProjects();
      },
    );
  }
}
