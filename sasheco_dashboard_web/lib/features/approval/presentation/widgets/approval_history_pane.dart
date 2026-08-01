import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../cubit/approval_cubit.dart';
import '../cubit/approval_state.dart';
import 'package:intl/intl.dart';

class ApprovalHistoryPane extends StatelessWidget {
  final String approvalId;

  const ApprovalHistoryPane({super.key, required this.approvalId});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.white.withValues(alpha: 0.9),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Approval History',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: BlocBuilder<ApprovalCubit, ApprovalState>(
                      builder: (context, state) {
                        if (state is ApprovalHistoryLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ApprovalHistoryLoaded) {
                          if (state.history.isEmpty) {
                            return const Center(child: Text('No history found.'));
                          }
                          return ListView.builder(
                            controller: controller,
                            itemCount: state.history.length,
                            itemBuilder: (context, index) {
                              final history = state.history[index];
                              return _buildTimelineItem(
                                context: context,
                                actionTaken: history.actionTaken,
                                comments: history.comments,
                                timestamp: history.timestamp,
                                userName: history.userName,
                                isLast: index == state.history.length - 1,
                              );
                            },
                          );
                        } else if (state is ApprovalError) {
                          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String actionTaken,
    required String comments,
    required DateTime timestamp,
    required String userName,
    required bool isLast,
  }) {
    final bool isApproved = actionTaken.toLowerCase().contains('approve');
    final bool isRejected = actionTaken.toLowerCase().contains('reject');
    
    Color iconColor = AppColors.textSecondary;
    IconData icon = Icons.info_outline;

    if (isApproved) {
      iconColor = AppColors.success;
      icon = Icons.check_circle;
    } else if (isRejected) {
      iconColor = Colors.red;
      icon = Icons.cancel;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        actionTaken,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(timestamp),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by $userName',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (comments.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        comments,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
