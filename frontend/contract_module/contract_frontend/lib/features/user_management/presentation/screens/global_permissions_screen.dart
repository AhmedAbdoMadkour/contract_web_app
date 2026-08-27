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
    bool hasContract = role.permissions.any((p) => p.contains('Approval') || p.contains('Secretary') || p.contains('Vendor'));
    bool hasFinance = role.permissions.any((p) => p.contains('Finance'));
    bool hasUsers = role.permissions.any((p) => p.contains('User'));
    bool hasEngineering = role.permissions.any((p) => p.contains('Engineering') || p.contains('Site'));
    
    var otherPerms = role.permissions.where((p) => 
        !p.contains('Approval') && !p.contains('Secretary') && !p.contains('Vendor') &&
        !p.contains('Finance') && !p.contains('User') && !p.contains('Engineering') && !p.contains('Site')
    ).toList();

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

class RolePermissionsCubit extends Cubit<List<String>> {
  RolePermissionsCubit(super.initialPermissions);

  void togglePermission(String permission, bool selected) {
    if (selected) {
      if (!state.contains(permission)) {
        emit([...state, permission]);
      }
    } else {
      if (state.contains(permission)) {
        emit(state.where((p) => p != permission).toList());
      }
    }
  }
}

class _EditRoleDialog extends StatelessWidget {
  final RoleModel role;
  final BuildContext parentContext;

  const _EditRoleDialog({required this.role, required this.parentContext});

  static const List<String> _allPermissions = [
    'Contract', 'Finance', 'Users', 'Engineering', 'Secretary', 'Approval', 'Vendor', 'Site'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RolePermissionsCubit(List.from(role.permissions)),
      child: Builder(
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Permissions: ${role.name}'),
            content: SizedBox(
              width: 400,
              child: BlocBuilder<RolePermissionsCubit, List<String>>(
                builder: (context, selectedPermissions) {
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _allPermissions.map((permission) {
                      final isSelected = selectedPermissions.contains(permission);
                      return FilterChip(
                        label: Text(permission),
                        selected: isSelected,
                        onSelected: (selected) {
                          context.read<RolePermissionsCubit>().togglePermission(permission, selected);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Builder(
                builder: (buttonContext) {
                  return ElevatedButton(
                    onPressed: () {
                      final selectedPermissions = buttonContext.read<RolePermissionsCubit>().state;
                      parentContext.read<RolesCubit>().updateRolePermissions(role.id, selectedPermissions);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  );
                }
              ),
            ],
          );
        },
      ),
    );
  }
}
