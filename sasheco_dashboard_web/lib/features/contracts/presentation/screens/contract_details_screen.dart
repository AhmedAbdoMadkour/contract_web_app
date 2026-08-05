import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Contract Details',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Viewing Contract ID: $contractId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Detailed contract view is under construction.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
