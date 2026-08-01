import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/cubit/finance_cubit.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/cubit/finance_state.dart';
import 'package:sasheco_dashboard_web/features/finance/data/model/finance_report_model.dart';
import 'package:sasheco_dashboard_web/features/finance/data/model/transaction_model.dart';
import 'package:intl/intl.dart';

class FinancialDashboardScreen extends StatefulWidget {
  const FinancialDashboardScreen({super.key});

  @override
  State<FinancialDashboardScreen> createState() => _FinancialDashboardScreenState();
}

class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceCubit>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<FinanceCubit, FinanceState>(
        listener: (context, state) {
          if (state.creationStatus == TransactionCreationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction processed successfully!')),
            );
          } else if (state.status == FinanceStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FinanceStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final report = state.report;
          final transactions = state.transactions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
            const SizedBox(height: 24),
            _buildKPICards(context, report),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPaymentSchedule(context, transactions),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildKeyTerms(context),
                ),
              ],
            ),
          ],
        ),
      );
      },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('financialOverview'.tr(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text('projectAlphaTerminalExpansion'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Financials Approved!')),
            );
          },
          icon: const Icon(Icons.check_circle_outline),
          label: Text('approveFinancials'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICards(BuildContext context, FinanceReportModel? report) {
    return Row(
      children: [
        Expanded(child: _buildKPICard(context, 'Total Revenue', report != null ? NumberFormat.currency(symbol: '\$').format(report.totalRevenue) : '\$0.00', Icons.attach_money, AppColors.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(context, 'Total Expenses', report != null ? NumberFormat.currency(symbol: '\$').format(report.totalExpenses) : '\$0.00', Icons.money_off, AppColors.accent)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(context, 'Net Income', report != null ? NumberFormat.currency(symbol: '\$').format(report.netIncome) : '\$0.00', Icons.account_balance_wallet, AppColors.success)),
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

  Widget _buildPaymentSchedule(BuildContext context, List<TransactionModel> transactions) {
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
              Text('Payment Schedule', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<FinanceCubit>().createTransaction(TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    description: 'New Milestone',
                    amount: 50000.0,
                    date: DateTime.now(),
                    type: 'Income'
                  ));
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Milestone'),
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: const WidgetStatePropertyAll(AppColors.background),
              columns: [
                const DataColumn(label: Text('Transaction ID')),
                DataColumn(label: Text('description'.tr())),
                const DataColumn(label: Text('Amount')),
                DataColumn(label: Text('status'.tr())),
                const DataColumn(label: Text('Action')),
              ],
              rows: transactions.map((t) => _buildPaymentRow(
                t.id, 
                t.description, 
                NumberFormat.currency(symbol: '\$').format(t.amount.abs()), 
                t.type, 
                t.type == 'Income' ? AppColors.success : AppColors.warning,
                context
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildPaymentRow(String id, String desc, String amount, String type, Color statusColor, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(desc)),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              type,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing payment...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Process'),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyTerms(BuildContext context) {
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
          Text('Financial Terms', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Penalty for Delay',
              hintText: 'e.g., 0.5% per week, max 10%',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Invoicing Requirements',
              hintText: 'e.g., Net 30 days',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Tax Considerations',
              hintText: 'e.g., VAT exclusive',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
