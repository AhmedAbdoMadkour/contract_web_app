import 'package:flutter/material.dart';

import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/engineering_cubit.dart';
import '../cubit/engineering_state.dart';
import '../cubit/create_engineering_project_form_cubit.dart';

class CreateEngineeringProjectScreen extends StatelessWidget {
  const CreateEngineeringProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateEngineeringProjectFormCubit(),
      child: const _CreateEngineeringProjectScreenView(),
    );
  }
}

class _CreateEngineeringProjectScreenView extends StatelessWidget {
  const _CreateEngineeringProjectScreenView();

  void _onCreateProject(BuildContext context) {
    final formCubit = context.read<CreateEngineeringProjectFormCubit>();
    if (formCubit.formKey.currentState!.validate()) {
      if (formCubit.state.startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }
      context.read<EngineeringCubit>().createProject(
        name: formCubit.nameController.text,
        description: formCubit.descController.text,
        startDate: formCubit.state.startDate!,
      );
    }
  }  

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<CreateEngineeringProjectFormCubit>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04), // Should be withValues but it's fine
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: formCubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Project Name', 'Enter project name', controller: formCubit.nameController),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTextField('Client Name', 'Enter client name'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField('Project Type', ['Infrastructure', 'Residential', 'Commercial', 'Industrial']),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTextField('Estimated Cost', '\$ 0.00', isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<CreateEngineeringProjectFormCubit, CreateEngineeringProjectFormState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildDateField(context, 'Start Date', state.startDate, (date) => formCubit.setStartDate(date)),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildDateField(context, 'End Date', state.endDate, (date) => formCubit.setEndDate(date)),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Project Location', 'Enter precise location address'),
                    const SizedBox(height: 24),
                    _buildTextField('Description', 'Enter project description and objectives', maxLines: 4, controller: formCubit.descController),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 16),
                        BlocConsumer<EngineeringCubit, EngineeringState>(
                          listener: (context, state) {
                            if (state is EngineeringProjectCreated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Project created successfully!')),
                              );
                              Navigator.of(context).pop();
                            } else if (state is EngineeringError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is EngineeringLoading;
                            return ElevatedButton(
                              onPressed: isLoading ? null : () => _onCreateProject(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Create Project', style: TextStyle(fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 8),
        Text(
          'Create New Project',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {bool isNumber = false, int maxLines = 1, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String label, DateTime? date, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: date != null ? "${date.toLocal()}".split(' ')[0] : '',
          ),
          decoration: InputDecoration(
            hintText: 'Select date',
            suffixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
