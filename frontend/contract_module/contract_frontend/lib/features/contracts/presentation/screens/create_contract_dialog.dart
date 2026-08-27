import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/create_contract_form_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_state.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_state.dart';

class CreateContractDialog extends StatelessWidget {
  const CreateContractDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure we have the latest projects and vendors
    context.read<EngineeringCubit>().fetchProjects();
    context.read<VendorCubit>().getVendors(page: 1, pageSize: 100);

    return BlocProvider(
      create: (context) => CreateContractFormCubit(),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: const _CreateContractDialogView(),
        ),
      ),
    );
  }
}

class _CreateContractDialogView extends StatelessWidget {
  const _CreateContractDialogView();

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<CreateContractFormCubit>();
    return BlocBuilder<CreateContractFormCubit, CreateContractFormState>(
      builder: (context, state) {
        return Form(
          key: formCubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Create New Contract', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Project Dropdown
              const Text('Select Project', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<EngineeringCubit, EngineeringState>(
                builder: (context, engState) {
                  List<DropdownMenuItem<String>> projectItems = [];
                  if (engState is EngineeringProjectsLoaded) {
                    projectItems = engState.projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList();
                  } else if (engState is EngineeringContractsLoaded) {
                    projectItems = engState.projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList();
                  }
                  
                  return DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Select Project'),
                    value: state.projectId,
                    items: projectItems,
                    onChanged: (val) {
                      if (val != null) formCubit.setProject(val);
                    },
                    validator: (val) => val == null ? 'Please select a project' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Vendor Dropdown
              const Text('Select Vendor', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<VendorCubit, VendorState>(
                builder: (context, vendorState) {
                  List<DropdownMenuItem<String>> vendorItems = [];
                  if (vendorState is VendorLoaded) {
                    vendorItems = vendorState.vendors.map((v) => DropdownMenuItem(value: v.id, child: Text(v.name))).toList();
                  }
                  
                  return DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Select Vendor'),
                    value: state.vendorId,
                    items: vendorItems,
                    onChanged: (val) {
                      if (val != null) formCubit.setVendor(val);
                    },
                    validator: (val) => val == null ? 'Please select a vendor' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              const Text('Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: formCubit.termsController,
                maxLines: 4,
                decoration: _inputDecoration('Enter initial terms and conditions...'),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter terms' : null,
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formCubit.formKey.currentState!.validate()) {
                        await context.read<ContractsCubit>().createContract(
                          state.projectId!,
                          state.vendorId!,
                          formCubit.termsController.text,
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text('Create Draft'),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
