import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/user_management_cubit.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/user_management_state.dart';
import 'package:sasheco_dashboard_web/features/user_management/data/model/user_model.dart';
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'analyst';
  final _formKey = GlobalKey<FormState>();

  Uint8List? _avatarBytes;
  String? _avatarFileName;

  final Map<String, Map<String, bool>> _permissions = {
    'Financial Dashboard': {'View': false, 'Edit': false, 'Admin': false},
    'Client Records': {'View': true, 'Edit': false, 'Admin': false},
    'System Settings': {'View': false, 'Edit': false, 'Admin': false},
  };

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _avatarBytes = result.files.first.bytes;
        _avatarFileName = result.files.first.name;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserManagementCubit, UserManagementState>(
      listener: (context, state) {
        if (state is UserManagementOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          _nameController.clear();
          _emailController.clear();
        } else if (state is UserManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(backgroundColor: Colors.transparent, body: 
        SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
                          child: _avatarBytes == null
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
                                  child: _buildTextField('Full Name', 'e.g. Jane Doe', controller: _nameController, validator: (val) {
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
                                  child: _buildTextField('Email', 'e.g. user@example.com', controller: _emailController, validator: (val) {
                                    if (val == null || val.isEmpty) return 'Email is required';
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
                                        value: _selectedRole,
                                        items: const [
                                          DropdownMenuItem(value: 'analyst', child: Text('Financial Analyst')),
                                          DropdownMenuItem(value: 'manager', child: Text('Project Manager')),
                                          DropdownMenuItem(value: 'admin', child: Text('System Administrator')),
                                          DropdownMenuItem(value: 'engineer', child: Text('Engineer')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(() {
                                              _selectedRole = val;
                                            });
                                          }
                                        },
                                        hint: const Text('Select Role'),
                                      ),
                                    ],
                                  ),
                                ),
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
                  _buildPermissionsTable(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _nameController.clear();
                          _emailController.clear();
                          setState(() {
                            _avatarBytes = null;
                            _avatarFileName = null;
                            _permissions.forEach((k, v) {
                              v['View'] = false;
                              v['Edit'] = false;
                              v['Admin'] = false;
                            });
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final user = UserModel(
                              id: '', // Generated by backend usually
                              name: _nameController.text,
                              email: _emailController.text,
                              role: _selectedRole,
                              isActive: true,
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
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Module')),
        DataColumn(label: Text('View')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Admin')),
      ],
      rows: _permissions.keys.map((module) {
        return _buildPermissionRow(module);
      }).toList(),
    );
  }

  DataRow _buildPermissionRow(String module) {
    return DataRow(
      cells: [
        DataCell(Text(module)),
        DataCell(
          Semantics(
            label: '$module view permission',
            child: Checkbox(
              value: _permissions[module]!['View'],
              onChanged: (v) {
                if (v != null) {
                  setState(() => _permissions[module]!['View'] = v);
                }
              },
            ),
          ),
        ),
        DataCell(
          Semantics(
            label: '$module edit permission',
            child: Checkbox(
              value: _permissions[module]!['Edit'],
              onChanged: (v) {
                if (v != null) {
                  setState(() => _permissions[module]!['Edit'] = v);
                }
              },
            ),
          ),
        ),
        DataCell(
          Semantics(
            label: '$module admin permission',
            child: Checkbox(
              value: _permissions[module]!['Admin'],
              onChanged: (v) {
                if (v != null) {
                  setState(() => _permissions[module]!['Admin'] = v);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
