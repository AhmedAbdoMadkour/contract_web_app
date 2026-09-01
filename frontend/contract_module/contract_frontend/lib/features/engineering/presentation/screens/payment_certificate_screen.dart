import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/payment_certificate_cubit.dart';
import '../cubit/payment_certificate_state.dart';
import '../../data/model/payment_certificate_model.dart';

class PaymentCertificateScreen extends StatelessWidget {
  const PaymentCertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCertificateCubit()..loadDummyData(),
      child: const PaymentCertificateView(),
    );
  }
}

class PaymentCertificateView extends StatelessWidget {
  const PaymentCertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Certificate'),
      ),
      body: BlocBuilder<PaymentCertificateCubit, PaymentCertificateState>(
        builder: (context, state) {
          if (state.status == PaymentCertificateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == PaymentCertificateStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.certificate == null) {
            return const Center(child: Text('No data found'));
          }

          final cert = state.certificate!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, cert),
                const SizedBox(height: 24),
                _buildDataGridMatrix(context, cert),
                const SizedBox(height: 24),
                _buildFooterSummary(context, cert),
                const SizedBox(height: 24),
                _buildWorkflowBottomBar(context, cert),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, PaymentCertificateModel cert) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Header Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Row(
              children: [
                Expanded(child: _buildInfoItem('Certificate No.', cert.certificateNumber)),
                Expanded(child: _buildInfoItem('Date', cert.date.toLocal().toString().split(' ')[0])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildInfoItem('Project Name', cert.projectName)),
                Expanded(child: _buildInfoItem('Vendor Name', cert.vendorName)),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoItem('Contract ID', cert.contractId),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDataGridMatrix(BuildContext context, PaymentCertificateModel cert) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Data Matrix',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Unit Price')),
                  DataColumn(label: Text('Prev Qty')),
                  DataColumn(label: Text('Current Qty')),
                  DataColumn(label: Text('Total Qty')),
                  DataColumn(label: Text('Prev Total')),
                  DataColumn(label: Text('Current Total')),
                ],
                rows: cert.items.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.description)),
                    DataCell(Text(item.unitPrice.toStringAsFixed(2))),
                    DataCell(Text(item.quantityPrevious.toStringAsFixed(2))),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          initialValue: item.quantityCurrent.toStringAsFixed(2),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) {
                            final newQty = double.tryParse(val) ?? 0.0;
                            context.read<PaymentCertificateCubit>().updateItemQuantity(item.id, newQty);
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(item.quantityTotal.toStringAsFixed(2))),
                    DataCell(Text(item.totalPrevious.toStringAsFixed(2))),
                    DataCell(Text(item.totalCurrent.toStringAsFixed(2))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSummary(BuildContext context, PaymentCertificateModel cert) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Summary & Totals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildSummaryRow('Total Previous', cert.totalPrevious),
            _buildSummaryRow('Current Total', cert.currentTotal),
            const Divider(),
            _buildSummaryRow('Net Payable', cert.netPayable, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 32),
          SizedBox(
            width: 150,
            child: Text(
              amount.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowBottomBar(BuildContext context, PaymentCertificateModel cert) {
    final commentsController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Workflow & Approval',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentsController,
            decoration: const InputDecoration(
              labelText: 'Comments (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: (cert.approval?.isApprovedByEngineering ?? false)
                    ? null
                    : () {
                        context.read<PaymentCertificateCubit>().approveByEngineering(
                              commentsController.text,
                            );
                      },
                icon: const Icon(Icons.engineering),
                label: Text((cert.approval?.isApprovedByEngineering ?? false)
                    ? 'Engineering Approved'
                    : 'Approve (Engineering)'),
              ),
              ElevatedButton.icon(
                onPressed: (cert.approval?.isApprovedByFinance ?? false)
                    ? null
                    : () {
                        context.read<PaymentCertificateCubit>().approveByFinance(
                              commentsController.text,
                            );
                      },
                icon: const Icon(Icons.account_balance),
                label: Text((cert.approval?.isApprovedByFinance ?? false)
                    ? 'Finance Approved'
                    : 'Approve (Finance)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
