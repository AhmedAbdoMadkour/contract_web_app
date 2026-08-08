import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/contract_model.dart';
import '../cubit/contracts_cubit.dart';
import 'contract_card.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class KanbanBoard extends StatelessWidget {
  final List<ContractModel> contracts;

  const KanbanBoard({super.key, required this.contracts});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumn(context, 'Draft', AppColors.textSecondary),
        const SizedBox(width: 24),
        _buildColumn(context, 'Active', AppColors.primary),
        const SizedBox(width: 24),
        _buildColumn(context, 'Completed', AppColors.success),
        const SizedBox(width: 24),
        _buildColumn(context, 'Terminated', AppColors.warning),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, String status, Color color) {
    final columnContracts = contracts.where((c) => c.status == status).toList();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    status,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${columnContracts.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // Droppable area
            Expanded(
              child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  final contractId = details.data;
                  context.read<ContractsCubit>().updateContractStatus(contractId, status);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: candidateData.isNotEmpty ? color.withOpacity(0.05) : Colors.transparent,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: columnContracts.length,
                      itemBuilder: (context, index) {
                        final contract = columnContracts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Draggable<String>(
                            data: contract.id,
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 300,
                                child: ContractCard(contract: contract, isDragging: true),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: ContractCard(contract: contract),
                            ),
                            child: InkWell(
                              onTap: () => context.push('/contracts/${contract.id}'),
                              child: ContractCard(contract: contract),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
