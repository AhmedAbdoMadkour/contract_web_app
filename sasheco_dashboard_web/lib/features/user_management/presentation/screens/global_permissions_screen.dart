import 'package:flutter/material.dart';

import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class GlobalPermissionsScreen extends StatelessWidget {
  const GlobalPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: 
      Column(
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
              child: ListView(
                children: [
                  const Text('Role Permissions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Contract Module')),
                      DataColumn(label: Text('Finance Module')),
                      DataColumn(label: Text('Users Module')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      _buildRoleRow('Administrator', 'Full Access', 'Full Access', 'Full Access'),
                      _buildRoleRow('Project Manager', 'Read/Write', 'Read Only', 'None'),
                      _buildRoleRow('Financial Analyst', 'Read Only', 'Read/Write', 'None'),
                      _buildRoleRow('Auditor', 'Read Only', 'Read Only', 'Read Only'),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DataRow _buildRoleRow(String role, String contract, String finance, String users) {
    return DataRow(
      cells: [
        DataCell(Text(role, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Chip(label: Text(contract))),
        DataCell(Chip(label: Text(finance))),
        DataCell(Chip(label: Text(users))),
        DataCell(
          Semantics(
            label: 'Edit permissions for $role',
            button: true,
            child: TextButton(onPressed: () {}, child: const Text('Edit')),
          ),
        ),
      ],
    );
  }
}
