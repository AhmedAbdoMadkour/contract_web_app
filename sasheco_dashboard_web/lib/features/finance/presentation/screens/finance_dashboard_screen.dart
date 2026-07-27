import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

import '../cubit/finance_cubit.dart';
import '../../data/model/transaction_model.dart';

class FinanceDashboardScreen extends StatelessWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Zone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FinancePro Dashboard',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'SASHECO Infrastructure Contract',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accent, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Active',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text('Export PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FinanceCubit>().createTransaction(
                        TransactionModel(
                          id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
                          amount: 250000,
                          date: DateTime.now(),
                          description: 'Initial Deposit Payment',
                          status: 'Processing',
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      elevation: 0,
                    ),
                    child: const Text('Process Payment', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          // Top Cards Row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Financial Overview Card (Left/Center Top, ~60% width)
                Expanded(
                  flex: 6,
                  child: _buildWhiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Financial Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricItem(
                                title: 'TOTAL CONTRACT VALUE',
                                value: '\$1,250,000',
                                valueColor: AppColors.textPrimary,
                              ),
                            ),
                            Container(width: 1, height: 50, color: AppColors.border),
                            Expanded(
                              child: _buildMetricItem(
                                title: 'DISBURSED AMOUNT',
                                value: '\$850,000',
                                valueColor: AppColors.textPrimary,
                                icon: Icons.check_circle,
                                iconColor: AppColors.success,
                              ),
                            ),
                            Container(width: 1, height: 50, color: AppColors.border),
                            Expanded(
                              child: _buildMetricItem(
                                title: 'REMAINING BALANCE',
                                value: '\$400,000',
                                valueColor: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Disbursement Progress',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('\$0', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const LinearProgressIndicator(
                                  value: 0.68,
                                  minHeight: 12,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('\$1.25M', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            '68% Completed',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Key Terms Card (Right Top, ~40% width)
                Expanded(
                  flex: 4,
                  child: _buildWhiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Key Terms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTermRow(
                          icon: Icons.warning_rounded,
                          iconColor: AppColors.error,
                          title: 'Late Payment Penalties',
                          description: '2% per month on outstanding balances after 30 days of invoice date.',
                        ),
                        const SizedBox(height: 24),
                        _buildTermRow(
                          icon: Icons.calendar_month,
                          iconColor: AppColors.info,
                          title: 'Payment Windows',
                          description: 'Invoices to be paid within 15 net days upon milestone approval.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Payment Schedule & Milestones (Full Width Bottom)
          Expanded(
            child: _buildWhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Schedule & Milestones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildDataTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required Color valueColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: iconColor, size: 24),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(AppColors.background),
              dataRowMaxHeight: 70,
              dataRowMinHeight: 60,
              columns: const [
                DataColumn(label: Text('MILESTONE', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                DataColumn(label: Text('DUE DATE', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
              ],
              rows: [
                _buildDataRow(
                  milestone: 'Initial Deposit (20%)',
                  dueDate: 'Oct 01, 2025',
                  amount: '\$250,000',
                  status: 'Completed',
                  statusColor: AppColors.success,
                  showReviewAction: false,
                ),
                _buildDataRow(
                  milestone: 'Foundation Phase (30%)',
                  dueDate: 'Dec 15, 2025',
                  amount: '\$375,000',
                  status: 'Completed',
                  statusColor: AppColors.success,
                  showReviewAction: false,
                ),
                _buildDataRow(
                  milestone: 'Structural Completion (20%)',
                  dueDate: 'Mar 10, 2026',
                  amount: '\$225,000',
                  status: 'Completed',
                  statusColor: AppColors.success,
                  showReviewAction: false,
                ),
                _buildDataRow(
                  milestone: 'Interior Finishing (15%)',
                  dueDate: 'Jul 05, 2026',
                  amount: '\$187,500',
                  status: 'Pending Approval',
                  statusColor: AppColors.warning,
                  showReviewAction: true,
                ),
                _buildDataRow(
                  milestone: 'Final Handover (15%)',
                  dueDate: 'Nov 20, 2026',
                  amount: '\$212,500',
                  status: 'Upcoming',
                  statusColor: AppColors.textDisabled,
                  showReviewAction: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow({
    required String milestone,
    required String dueDate,
    required String amount,
    required String status,
    required Color statusColor,
    required bool showReviewAction,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(milestone, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
        DataCell(Text(dueDate, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        DataCell(_buildStatusPill(status, statusColor)),
        DataCell(showReviewAction
            ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                  minimumSize: const Size(0, 36),
                ),
                child: const Text('Review', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              )
            : IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onPressed: () {},
              )),
      ],
    );
  }

  Widget _buildStatusPill(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: color == AppColors.textDisabled ? AppColors.textSecondary : color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
