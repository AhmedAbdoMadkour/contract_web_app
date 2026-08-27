import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/create_secretary_task_request.dart';
import '../../data/repository/secretary_repository.dart';
import 'secretary_state.dart';

import 'package:flutter/material.dart';

class SecretaryCubit extends Cubit<SecretaryState> {
  final SecretaryRepository _repository;
  final TextEditingController editorController = TextEditingController();

  SecretaryCubit(this._repository) : super(SecretaryInitial());

  @override
  Future<void> close() {
    editorController.dispose();
    return super.close();
  }

  Future<void> fetchInbox() async {
    emit(SecretaryLoading());
    final result = await _repository.getInbox();
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (items) => emit(SecretaryInboxLoaded(items)),
    );
  }

  Future<void> fetchTasks() async {
    emit(SecretaryLoading());
    final result = await _repository.getTasks();
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (tasks) => emit(SecretaryTasksLoaded(tasks)),
    );
  }

  Future<void> createTask(CreateSecretaryTaskRequest request) async {
    emit(SecretaryLoading());
    final result = await _repository.createTask(request);
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (_) => emit(const SecretaryTaskOperationSuccess("Task created successfully")),
    );
  }

  Future<void> completeTask(String id) async {
    emit(SecretaryLoading());
    final result = await _repository.completeTask(id);
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (_) => emit(const SecretaryTaskOperationSuccess("Task completed successfully")),
    );
  }

  Future<void> uploadDocument(List<int> fileBytes, String fileName) async {
    emit(SecretaryLoading());
    final result = await _repository.uploadDocument(fileBytes, fileName);
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (_) => emit(const SecretaryTaskOperationSuccess("Document uploaded successfully")),
    );
  }

  Future<void> saveDraft(String id, String terms) async {
    emit(SecretaryLoading());
    final result = await _repository.updateLegacyTerms(id, terms);
    result.fold(
      (failure) => emit(SecretaryError(failure.message)),
      (_) {
        emit(const SecretaryTaskOperationSuccess("Draft saved successfully"));
        fetchTasks(); // refresh after save
      },
    );
  }
}
