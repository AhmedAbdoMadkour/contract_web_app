import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../cubit/engineering_cubit.dart';
import '../cubit/create_contract_item_form_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateContractItemDialog extends StatelessWidget {
  final String contractId;
  const CreateContractItemDialog({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateContractItemFormCubit(),
      child: Dialog(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 550,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _CreateContractItemDialogView(contractId: contractId),
        ),
      ),
    );
  }
}

class _CreateContractItemDialogView extends StatelessWidget {
  final String contractId;
  const _CreateContractItemDialogView({required this.contractId});

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<CreateContractItemFormCubit>();
    return Form(
      key: formCubit.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add New Contract Item', 
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Define a new item to be added to the project BOQ.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          TextFormField(
            controller: formCubit.itemCodeController,
            decoration: _inputDecoration('Item Code', Icons.qr_code),
            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: formCubit.itemNameController,
            decoration: _inputDecoration('Item Name', Icons.description_outlined),
            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: formCubit.quantityController,
                  decoration: _inputDecoration('Quantity', Icons.numbers),
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: formCubit.priceController,
                  decoration: _inputDecoration('Unit Price', Icons.attach_money),
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (formCubit.formKey.currentState!.validate()) {
                    context.read<EngineeringCubit>().addContractItem(
                      contractId: contractId,
                      price: double.parse(formCubit.priceController.text),
                      quantity: int.parse(formCubit.quantityController.text),
                      itemCode: formCubit.itemCodeController.text,
                      itemName: formCubit.itemNameController.text,
                    );
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Add Item', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
      filled: true,
      fillColor: AppColors.background.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
