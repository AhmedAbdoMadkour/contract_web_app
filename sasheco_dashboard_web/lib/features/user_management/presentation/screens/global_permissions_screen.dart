import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import '../cubit/roles_cubit.dart';
import '../../data/model/role_model.dart';

class GlobalPermissionsScreen extends StatelessWidget {
  const GlobalPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Permissions',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          const Text('Manage default access levels across the platform.'),
          const SizedBox(height: 24),
          Expanded(
            child: GlassContainer(
              child: BlocBuilder<RolesCubit, RolesState>(
                builder: (context, state) {
                  if (state is RolesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RolesError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
                  } else if (state is RolesLoaded) {
                    return ListView(
                      children: [
                        const Text('Role Permissions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Contract Module')),
                              DataColumn(label: Text('Finance Module')),
                              DataColumn(label: Text('Users Module')),
                              DataColumn(label: Text('Engineering')),
                              DataColumn(label: Text('Other')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: state.roles.map((role) => _buildRoleRow(context, role)).toList(),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow _buildRoleRow(BuildContext context, RoleModel role) {
    bool hasContract = role.permissions.contains('Contract');
    bool hasFinance = role.permissions.contains('Finance');
    bool hasUsers = role.permissions.contains('Users');
    bool hasEngineering = role.permissions.contains('Engineering');
    
    var otherPerms = role.permissions.where((p) => !['Contract', 'Finance', 'Users', 'Engineering'].contains(p)).toList();

    return DataRow(
      cells: [
        DataCell(Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(_buildStatusChip(hasContract)),
        DataCell(_buildStatusChip(hasFinance)),
        DataCell(_buildStatusChip(hasUsers)),
        DataCell(_buildStatusChip(hasEngineering)),
        DataCell(Text(otherPerms.join(', '))),
        DataCell(
          Semantics(
            label: 'Edit permissions for ${role.name}',
            button: true,
            child: TextButton(
              onPressed: () => _showEditDialog(context, role),
              child: const Text('Edit'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(bool hasPermission) {
    return Chip(
      label: Text(hasPermission ? 'Access' : 'None'),
      backgroundColor: hasPermission ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      labelStyle: TextStyle(color: hasPermission ? Colors.green : Colors.red),
    );
  }

  void _showEditDialog(BuildContext context, RoleModel role) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _EditRoleDialog(role: role, parentContext: context);
      },
    );
  }
}

class _EditRoleDialog extends StatefulWidget {
  final RoleModel role;
  final BuildContext parentContext;

  const _EditRoleDialog({required this.role, required this.parentContext});

  @override
  State<_EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<_EditRoleDialog> {
  final List<String> _allPermissions = [
    'Contract', 'Finance', 'Users', 'Engineering', 'Secretary', 'Approval', 'Vendor', 'Site'
  ];
  late List<String> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    _selectedPermissions = List.from(widget.role.permissions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Permissions: ${widget.role.name}'),
      content: SizedBox(
        width: 400,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _allPermissions.map((permission) {
            final isSelected = _selectedPermissions.contains(permission);
            return FilterChip(
              label: Text(permission),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPermissions.add(permission);
                  } else {
                    _selectedPermissions.remove(permission);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.parentContext.read<RolesCubit>().updateRolePermissions(widget.role.id, _selectedPermissions);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
