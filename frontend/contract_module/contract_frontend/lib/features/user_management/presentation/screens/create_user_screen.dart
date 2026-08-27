import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/user_management_cubit.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/user_management_state.dart';
import 'package:sasheco_dashboard_web/features/user_management/data/model/user_model.dart';
import 'package:go_router/go_router.dart';

import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/create_user_form_cubit.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUserFormCubit(),
      child: const _CreateUserScreenView(),
    );
  }
}

class _CreateUserScreenView extends StatelessWidget {
  const _CreateUserScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserManagementCubit, UserManagementState>(
      listener: (context, state) {
        if (state is UserManagementOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<CreateUserFormCubit>().clearForm();
          context.go('/user-review');
        } else if (state is UserManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: BlocBuilder<CreateUserFormCubit, CreateUserFormState>(
            builder: (context, formState) {
              final formCubit = context.read<CreateUserFormCubit>();
              return Form(
                key: formCubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create User',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Provision a new user account and assign system access permissions.'),
                    const SizedBox(height: 24),
                    GlassContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('User Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => formCubit.pickImage(),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                  backgroundImage: formState.avatarBytes != null ? MemoryImage(formState.avatarBytes!) : null,
                                  child: formState.avatarBytes == null
                                      ? const Icon(Icons.add_a_photo, size: 30, color: AppColors.textSecondary)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField('User Number', 'USR-4029', readOnly: true),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildTextField('Full Name', 'e.g. Jane Doe', controller: formCubit.nameController, validator: (val) {
                                            if (val == null || val.isEmpty) return 'Name is required';
                                            return null;
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField('Email', 'e.g. user@example.com', controller: formCubit.emailController, keyboardType: TextInputType.emailAddress, validator: (val) {
                                            if (val == null || val.isEmpty) return 'Email is required';
                                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                            if (!emailRegex.hasMatch(val)) return 'Enter a valid email';
                                            return null;
                                          }),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Position / Role', style: TextStyle(color: AppColors.textSecondary)),
                                              const SizedBox(height: 8),
                                              DropdownButtonFormField<String>(
                                                value: formState.selectedRole,
                                                items: const [
                                                  DropdownMenuItem(value: 'analyst', child: Text('Financial Analyst')),
                                                  DropdownMenuItem(value: 'manager', child: Text('Project Manager')),
                                                  DropdownMenuItem(value: 'admin', child: Text('System Administrator')),
                                                  DropdownMenuItem(value: 'engineer', child: Text('Engineer')),
                                                ],
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    formCubit.setRole(val);
                                                  }
                                                },
                                                hint: const Text('Select Role'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField('Password', 'Enter secure password', controller: formCubit.passwordController, obscureText: true, validator: (val) {
                                            if (val == null || val.isEmpty) return 'Password is required';
                                            if (val.length < 6) return 'Must be at least 6 characters';
                                            return null;
                                          }),
                                        ),
                                        const SizedBox(width: 16),
                                        const Expanded(child: SizedBox()), // Placeholder to keep grid alignment
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 32),
                          const Text('Access Permissions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildPermissionsTable(context, formState),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => formCubit.clearForm(),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (formCubit.formKey.currentState?.validate() ?? false) {
                                    final user = UserModel(
                                      id: '', // Generated by backend usually
                                      name: formCubit.nameController.text,
                                      email: formCubit.emailController.text,
                                      role: formState.selectedRole,
                                      isActive: true,
                                      password: formCubit.passwordController.text,
                                      avatarBytes: formState.avatarBytes,
                                    );
                                    context.read<UserManagementCubit>().createUser(user);
                                  }
                                },
                                icon: const Icon(Icons.person_add),
                                label: const Text('Create User'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    String hint, {
    bool readOnly = false, 
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsTable(BuildContext context, CreateUserFormState formState) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Module')),
        DataColumn(label: Text('View')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Admin')),
      ],
      rows: formState.permissions.keys.map((module) {
        return _buildPermissionRow(context, module, formState.permissions[module]!);
      }).toList(),
    );
  }

  DataRow _buildPermissionRow(BuildContext context, String module, Map<String, bool> accessMap) {
    final formCubit = context.read<CreateUserFormCubit>();
    return DataRow(
      cells: [
        DataCell(Text(module)),
        DataCell(
          Semantics(
            label: '$module view permission',
            child: Checkbox(
              value: accessMap['View'],
              onChanged: (v) {
                if (v != null) {
                  formCubit.togglePermission(module, 'View', v);
                }
              },
            ),
          ),
        ),
        DataCell(
          Semantics(
            label: '$module edit permission',
            child: Checkbox(
              value: accessMap['Edit'],
              onChanged: (v) {
                if (v != null) {
                  formCubit.togglePermission(module, 'Edit', v);
                }
              },
            ),
          ),
        ),
        DataCell(
          Semantics(
            label: '$module admin permission',
            child: Checkbox(
              value: accessMap['Admin'],
              onChanged: (v) {
                if (v != null) {
                  formCubit.togglePermission(module, 'Admin', v);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
