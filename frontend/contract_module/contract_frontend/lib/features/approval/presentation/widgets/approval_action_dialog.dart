import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovalActionDialogState {
  final String comments;
  final String? evidenceUrl;
  final bool isRejecting;

  const ApprovalActionDialogState({
    this.comments = '',
    this.evidenceUrl,
    this.isRejecting = false,
  });

  ApprovalActionDialogState copyWith({
    String? comments,
    String? evidenceUrl,
    bool? isRejecting,
  }) {
    return ApprovalActionDialogState(
      comments: comments ?? this.comments,
      evidenceUrl: evidenceUrl ?? this.evidenceUrl,
      isRejecting: isRejecting ?? this.isRejecting,
    );
  }
}

class ApprovalActionDialogCubit extends Cubit<ApprovalActionDialogState> {
  ApprovalActionDialogCubit() : super(const ApprovalActionDialogState());

  void setComments(String comments) {
    if (state.isRejecting && comments.isNotEmpty) {
      emit(state.copyWith(comments: comments, isRejecting: false));
    } else {
      emit(state.copyWith(comments: comments));
    }
  }

  void attachEvidence(String url) {
    emit(state.copyWith(evidenceUrl: url));
  }

  void setRejecting(bool val) {
    emit(state.copyWith(isRejecting: val));
  }
}

class ApprovalActionDialog extends StatelessWidget {
  final String approvalId;
  final Function(String id, String comments, String? evidenceUrl) onApprove;
  final Function(String id, String comments, String? evidenceUrl) onReject;

  const ApprovalActionDialog({
    super.key,
    required this.approvalId,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApprovalActionDialogCubit(),
      child: _ApprovalActionDialogContent(
        approvalId: approvalId,
        onApprove: onApprove,
        onReject: onReject,
      ),
    );
  }
}

class _ApprovalActionDialogContent extends StatelessWidget {
  final String approvalId;
  final Function(String id, String comments, String? evidenceUrl) onApprove;
  final Function(String id, String comments, String? evidenceUrl) onReject;

  const _ApprovalActionDialogContent({
    super.key,
    required this.approvalId,
    required this.onApprove,
    required this.onReject,
  });

  void _pickFile(BuildContext context) async {
    // Mocking file picker
    final url = 'https://mock-storage.com/evidence_${DateTime.now().millisecondsSinceEpoch}.pdf';
    context.read<ApprovalActionDialogCubit>().attachEvidence(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock evidence attached.')),
    );
  }

  void _handleReject(BuildContext context, ApprovalActionDialogState state) {
    if (state.comments.trim().isEmpty) {
      context.read<ApprovalActionDialogCubit>().setRejecting(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comments are mandatory for rejection.')),
      );
      return;
    }
    onReject(approvalId, state.comments.trim(), state.evidenceUrl);
    Navigator.of(context).pop();
  }

  void _handleApprove(BuildContext context, ApprovalActionDialogState state) {
    onApprove(approvalId, state.comments.trim(), state.evidenceUrl);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovalActionDialogCubit, ApprovalActionDialogState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Approval Action',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your comments...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: state.isRejecting && state.comments.isEmpty ? Colors.red : Colors.white.withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: state.isRejecting && state.comments.isEmpty ? Colors.red : Colors.white.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: state.isRejecting && state.comments.isEmpty ? Colors.red : Colors.white),
                      ),
                    ),
                    onChanged: (val) {
                      context.read<ApprovalActionDialogCubit>().setComments(val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _pickFile(context),
                        icon: const Icon(Icons.attach_file, color: Colors.white),
                        label: const Text('Attach Evidence', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (state.evidenceUrl != null)
                        const Expanded(
                          child: Text(
                            'File attached',
                            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _handleReject(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text('Reject'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _handleApprove(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success.withValues(alpha: 0.9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text('Approve'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
