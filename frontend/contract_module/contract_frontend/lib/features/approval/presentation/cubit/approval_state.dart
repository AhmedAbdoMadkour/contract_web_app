import 'package:equatable/equatable.dart';
import '../../data/model/approval_model.dart';
import '../../data/model/approval_history_model.dart';

abstract class ApprovalState extends Equatable {
  const ApprovalState();

  @override
  List<Object?> get props => [];
}

class ApprovalInitial extends ApprovalState {}

class ApprovalLoading extends ApprovalState {}

class ApprovalLoaded extends ApprovalState {
  final List<ApprovalModel> approvals;

  const ApprovalLoaded(this.approvals);

  @override
  List<Object?> get props => [approvals];
}

class ApprovalHistoryLoading extends ApprovalState {}

class ApprovalHistoryLoaded extends ApprovalState {
  final List<ApprovalHistoryModel> history;

  const ApprovalHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class ApprovalActionLoading extends ApprovalState {
  final String approvalId;
  final List<ApprovalModel> currentApprovals;

  const ApprovalActionLoading(this.approvalId, this.currentApprovals);

  @override
  List<Object?> get props => [approvalId, currentApprovals];
}

class ApprovalActionSuccess extends ApprovalState {
  final String message;
  final List<ApprovalModel> currentApprovals;

  const ApprovalActionSuccess(this.message, this.currentApprovals);

  @override
  List<Object?> get props => [message, currentApprovals];
}

class ApprovalError extends ApprovalState {
  final String message;
  final List<ApprovalModel>? currentApprovals;

  const ApprovalError(this.message, {this.currentApprovals});

  @override
  List<Object?> get props => [message, currentApprovals];
}
