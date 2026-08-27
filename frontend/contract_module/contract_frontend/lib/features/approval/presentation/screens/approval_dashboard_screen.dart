import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../cubit/approval_cubit.dart';
import '../cubit/approval_state.dart';
import '../widgets/approval_action_dialog.dart';
import '../widgets/approval_history_pane.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';

class ApprovalDashboardScreen extends StatelessWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace stateful init with a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ApprovalCubit>().state is ApprovalInitial) {
        context.read<ApprovalCubit>().fetchApprovals();
      }
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<ApprovalCubit, ApprovalState>(
        listener: (context, state) {
          if (state is ApprovalActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ApprovalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          String? currentId;
          String currentStatus = 'Ready';
          if (state is ApprovalLoaded && state.approvals.isNotEmpty) {
            currentId = state.approvals.first.id;
            currentStatus = state.approvals.first.status;
          } else if (state is ApprovalActionSuccess && state.currentApprovals.isNotEmpty) {
            currentId = state.currentApprovals.first.id;
            currentStatus = state.currentApprovals.first.status;
          }

          if (currentId == null && state is ApprovalLoaded) {
            return const Center(child: Text("No pending approvals found."));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, currentId),
                    const SizedBox(height: 24),
                    _buildKPICards(context, currentStatus),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildDocumentViewer(context),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildRiskAssessment(context),
                              const SizedBox(height: 24),
                              _buildAuditTrail(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state is ApprovalLoading || state is ApprovalActionLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? currentId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract Approval',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Final Management Review',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: currentId == null ? null : () => _showActionDialog(context, currentId),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Take Action', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: currentId == null ? null : () => _showHistoryPane(context, currentId),
              icon: const Icon(Icons.history),
              label: const Text('View History', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 16),
            const ModuleExitButton(),
          ],
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => ApprovalActionDialog(
        approvalId: id,
        onApprove: (id, comments, evidenceUrl) {
          context.read<ApprovalCubit>().approveRequest(id, comments, evidenceUrl);
        },
        onReject: (id, comments, evidenceUrl) {
          context.read<ApprovalCubit>().rejectRequest(id, comments, evidenceUrl);
        },
      ),
    );
  }

  void _showHistoryPane(BuildContext context, String id) {
    context.read<ApprovalCubit>().fetchApprovalHistory(id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ApprovalHistoryPane(approvalId: id),
    );
  }


  Widget _buildKPICards(BuildContext context, String currentStatus) {
    return Row(
      children: [
        Expanded(child: _buildKPICard(context, 'Contract Value', '\$2,500,000.00', Icons.attach_money, AppColors.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(context, 'Risk Level', 'Low', Icons.security, AppColors.success)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(context, 'Pending Depts', '0', Icons.pending_actions, AppColors.textSecondary)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(context, 'Status', currentStatus, Icons.check_circle, AppColors.success)),
      ],
    );
  }

  Widget _buildKPICard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Document Viewer', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              const Row(
                children: [
                  Icon(Icons.zoom_in, color: AppColors.textSecondary),
                  SizedBox(width: 8),
                  Icon(Icons.zoom_out, color: AppColors.textSecondary),
                  SizedBox(width: 8),
                  Icon(Icons.fullscreen, color: AppColors.textSecondary),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 64, color: Colors.redAccent),
                  SizedBox(height: 16),
                  Text('Alpha_Terminal_Contract_Final.pdf', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  SizedBox(height: 8),
                  Text('Page 1 of 45', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAssessment(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('AI Risk Assessment', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Standard Terms Met', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      SizedBox(height: 4),
                      Text('All financial and engineering terms match standard organizational templates.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning, color: AppColors.warning, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unusual Payment Terms', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      SizedBox(height: 4),
                      Text('Advance payment is 10%, slightly higher than the usual 5% for this vendor.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTrail(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Approval Audit Trail', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 16),
          _buildAuditStep('Engineering Dept.', 'Approved by John Doe', 'Oct 24, 10:30 AM', true),
          _buildAuditStep('Secretary Dept.', 'Drafted & Validated by Sarah Lee', 'Oct 25, 09:15 AM', true),
          _buildAuditStep('Financial Dept.', 'Approved by Mike Smith', 'Oct 26, 14:00 PM', true),
          _buildAuditStep('Management Review', 'Pending Final Approval', '-', false),
        ],
      ),
    );
  }

  Widget _buildAuditStep(String department, String details, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? AppColors.success : AppColors.textDisabled,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(department, style: TextStyle(fontWeight: FontWeight.bold, color: isCompleted ? AppColors.primary : AppColors.textDisabled)),
                const SizedBox(height: 2),
                Text(details, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
