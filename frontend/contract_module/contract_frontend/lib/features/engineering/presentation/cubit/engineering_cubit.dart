import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/engineering_repository.dart';
import '../../data/model/engineering_project_model.dart';
import '../../data/model/contract_model.dart';
import 'engineering_state.dart';

class EngineeringCubit extends Cubit<EngineeringState> {
  final EngineeringRepository _repository;

  EngineeringCubit(this._repository) : super(EngineeringInitial());

  List<EngineeringProjectModel> _projects = [];

  Future<void> fetchProjects() async {
    emit(EngineeringLoading());
    final result = await _repository.getProjects();
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (projects) {
        _projects = projects;
        emit(EngineeringProjectsLoaded(projects));
        if (projects.isNotEmpty) {
          fetchProjectContracts(projects.first.id);
        }
      },
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

  Future<void> fetchProjectContracts(String projectId) async {
    emit(EngineeringLoading());
    final result = await _repository.getProjectContracts(projectId);
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (contracts) => emit(EngineeringContractsLoaded(contracts, _projects)),
    );
  }

  void setDragging(bool isDragging) {
    if (state is EngineeringContractsLoaded) {
      final currentState = state as EngineeringContractsLoaded;
      emit(currentState.copyWith(isDragging: isDragging));
    }
  }

  Future<void> uploadDrawing(String contractId, dynamic fileBytes, String fileName) async {
    final result = await _repository.uploadDrawing(
      contractId: contractId,
      fileBytes: fileBytes,
      fileName: fileName,
    );
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (_) {
        // Refetch to see the new drawing
        if (state is EngineeringContractsLoaded) {
          final s = state as EngineeringContractsLoaded;
          if (s.projects.isNotEmpty) {
            fetchProjectContracts(s.projects.first.id);
          }
        }
      },
    );
  }

  Future<void> addContractItem({
    required String contractId,
    required double price,
    required int quantity,
    required String descriptionEn,
    required String descriptionAr,
  }) async {
    final result = await _repository.addContractItem(
      contractId: contractId,
      price: price,
      quantity: quantity,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
    );
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (_) {
        // Find the project id of the contract we just updated
        if (state is EngineeringContractsLoaded) {
          final s = state as EngineeringContractsLoaded;
          if (s.projects.isNotEmpty) {
            fetchProjectContracts(s.projects.first.id);
          }
        }
      },
    );
  }

  Future<void> uploadBulkItems(String contractId, dynamic fileBytes, String fileName) async {
    final result = await _repository.uploadBulkItems(
      contractId: contractId,
      fileBytes: fileBytes,
      fileName: fileName,
    );
    result.fold(
      (failure) => emit(EngineeringError(failure.message)),
      (_) {
        // Refetch to see the new items
        if (state is EngineeringContractsLoaded) {
          final s = state as EngineeringContractsLoaded;
          if (s.projects.isNotEmpty) {
            fetchProjectContracts(s.projects.first.id);
          }
        }
      },
    );
  }
}
