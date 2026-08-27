
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/features/vendor/data/model/create_vendor_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_state.dart';

class CreateVendorFormState {
  final String name;
  final String contactPerson;
  final String email;
  final String phone;

  const CreateVendorFormState({
    this.name = '',
    this.contactPerson = '',
    this.email = '',
    this.phone = '',
  });

  CreateVendorFormState copyWith({
    String? name,
    String? contactPerson,
    String? email,
    String? phone,
  }) {
    return CreateVendorFormState(
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class CreateVendorFormCubit extends Cubit<CreateVendorFormState> {
  CreateVendorFormCubit() : super(const CreateVendorFormState());

  void setName(String value) => emit(state.copyWith(name: value));
  void setContactPerson(String value) => emit(state.copyWith(contactPerson: value));
  void setEmail(String value) => emit(state.copyWith(email: value));
  void setPhone(String value) => emit(state.copyWith(phone: value));
}

class CreateVendorDialog extends StatelessWidget {
  const CreateVendorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateVendorFormCubit(),
      child: const _CreateVendorDialogContent(),
    );
  }
}

class _CreateVendorDialogContent extends StatelessWidget {
  const _CreateVendorDialogContent({super.key});

  void _submit(BuildContext context) {
    final formState = context.read<CreateVendorFormCubit>().state;
    if (formState.name.trim().isEmpty || 
        formState.contactPerson.trim().isEmpty || 
        formState.email.trim().isEmpty || 
        formState.phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }

    final model = CreateVendorModel(
      name: formState.name.trim(),
      contactPerson: formState.contactPerson.trim(),
      email: formState.email.trim(),
      phone: formState.phone.trim(),
    );
    context.read<VendorCubit>().createVendor(model);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VendorCubit, VendorState>(
      listener: (context, state) {
        if (state is VendorOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        } else if (state is VendorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'addNewVendor'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Vendor Name', (val) => context.read<CreateVendorFormCubit>().setName(val)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Contact Person', (val) => context.read<CreateVendorFormCubit>().setContactPerson(val))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Email', (val) => context.read<CreateVendorFormCubit>().setEmail(val), keyboardType: TextInputType.emailAddress)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Phone', (val) => context.read<CreateVendorFormCubit>().setPhone(val), keyboardType: TextInputType.phone),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('cancel'.tr(), style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<VendorCubit, VendorState>(
                    builder: (context, state) {
                      final isLoading = state is VendorLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text('saveVendor'.tr(), style: const TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, {TextInputType? keyboardType}) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
