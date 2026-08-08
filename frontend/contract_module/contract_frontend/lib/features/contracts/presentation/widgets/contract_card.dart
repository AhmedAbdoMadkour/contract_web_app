import 'package:flutter/material.dart';
import '../../data/model/contract_model.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class ContractCard extends StatelessWidget {
  final ContractModel contract;
  final bool isDragging;

  const ContractCard({super.key, required this.contract, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: isDragging 
          ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]
          : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contract.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contract.clientName,
            style: const TextStyle(
              fontSize: 14, 
              color: AppColors.textSecondary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.attach_money, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  NumberFormat("#,##0").format(contract.amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.primary,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const Icon(Icons.drag_indicator, size: 16, color: AppColors.border),
            ],
          )
        ],
      ),
    );
  }
}
