import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'approval_state.dart';
import '../../data/repository/approval_repository.dart';
import '../../data/model/approval_model.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  final ApprovalRepository _repository;

  ApprovalCubit(this._repository) : super(ApprovalInitial());

  Future<void> fetchApprovals() async {
    emit(ApprovalLoading());
    
    final result = await _repository.getApprovals();
    
    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (approvals) => emit(ApprovalLoaded(approvals)),
    );
  }

  Future<void> fetchApprovalHistory(String id) async {
    emit(ApprovalHistoryLoading());
    
    final result = await _repository.getApprovalHistory(id);
    
    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (history) => emit(ApprovalHistoryLoaded(history)),
    );
  }

  Future<void> approveRequest(String id, String comments, String? evidenceUrl) async {
    List<ApprovalModel> currentApprovals = [];
    if (state is ApprovalLoaded) {
      currentApprovals = (state as ApprovalLoaded).approvals;
    } else if (state is ApprovalActionSuccess) {
      currentApprovals = (state as ApprovalActionSuccess).currentApprovals;
    } else if (state is ApprovalError) {
      currentApprovals = (state as ApprovalError).currentApprovals ?? [];
    }

    emit(ApprovalActionLoading(id, currentApprovals));

    final result = await _repository.approveApproval(id, comments, evidenceUrl);

    result.fold(
      (failure) => emit(ApprovalError(failure.message, currentApprovals: currentApprovals)),
      (success) {
        final updatedApprovals = currentApprovals.map((approval) {
          if (approval.id == id) {
            return ApprovalModel(
              id: approval.id,
              title: approval.title,
              description: approval.description,
              status: 'Approved',
              requestedBy: approval.requestedBy,
              createdAt: approval.createdAt,
            );
          }
          return approval;
        }).toList();
        
        emit(ApprovalActionSuccess('Status updated successfully.', updatedApprovals));
        emit(ApprovalLoaded(updatedApprovals));
      },
    );
  }

  Future<void> rejectRequest(String id, String comments, String? evidenceUrl) async {
    List<ApprovalModel> currentApprovals = [];
    if (state is ApprovalLoaded) {
      currentApprovals = (state as ApprovalLoaded).approvals;
    } else if (state is ApprovalActionSuccess) {
      currentApprovals = (state as ApprovalActionSuccess).currentApprovals;
    } else if (state is ApprovalError) {
      currentApprovals = (state as ApprovalError).currentApprovals ?? [];
    }

    emit(ApprovalActionLoading(id, currentApprovals));

    final result = await _repository.rejectApproval(id, comments, evidenceUrl);

    result.fold(
      (failure) => emit(ApprovalError(failure.message, currentApprovals: currentApprovals)),
      (success) {
        final updatedApprovals = currentApprovals.map((approval) {
          if (approval.id == id) {
            return ApprovalModel(
              id: approval.id,
              title: approval.title,
              description: approval.description,
              status: 'Rejected',
              requestedBy: approval.requestedBy,
              createdAt: approval.createdAt,
            );
          }
          return approval;
        }).toList();
        
        emit(ApprovalActionSuccess('Status updated successfully.', updatedApprovals));
        emit(ApprovalLoaded(updatedApprovals));
      },
    );
  }

  Future<void> _updateStatus(String id, String status) async {
    List<ApprovalModel> currentApprovals = [];
    if (state is ApprovalLoaded) {
      currentApprovals = (state as ApprovalLoaded).approvals;
    } else if (state is ApprovalActionSuccess) {
      currentApprovals = (state as ApprovalActionSuccess).currentApprovals;
    } else if (state is ApprovalError) {
      currentApprovals = (state as ApprovalError).currentApprovals ?? [];
    }

    emit(ApprovalActionLoading(id, currentApprovals));

    final result = await _repository.updateApprovalStatus(id, status);

    result.fold(
      (failure) => emit(ApprovalError(failure.message, currentApprovals: currentApprovals)),
      (success) {
        final updatedApprovals = currentApprovals.map((approval) {
          if (approval.id == id) {
            return ApprovalModel(
              id: approval.id,
              title: approval.title,
              description: approval.description,
              status: status,
              requestedBy: approval.requestedBy,
              createdAt: approval.createdAt,
            );
          }
          return approval;
        }).toList();
        
        emit(ApprovalActionSuccess('Status updated successfully.', updatedApprovals));
        emit(ApprovalLoaded(updatedApprovals));
      },
    );
  }

  Future<void> uploadDocument(PlatformFile file) async {
    emit(ApprovalLoading());
    final result = await _repository.uploadDocument(file);
    result.fold(
      (failure) => emit(ApprovalError(failure.message)),
      (url) => emit(ApprovalActionSuccess("Document uploaded successfully", state is ApprovalLoaded ? (state as ApprovalLoaded).approvals : [])),
    );
  }
}
