import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_state.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/screens/create_vendor_dialog.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  void _showCreateVendorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<VendorCubit>(),
        child: const CreateVendorDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vendorManagement'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Manage vendor profiles, track details, and monitor statuses.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreateVendorDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('addVendor'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const ModuleExitButton(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.all(0), // Removed padding for flush table
              child: BlocBuilder<VendorCubit, VendorState>(
                builder: (context, state) {
                  if (state is VendorLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  } else if (state is VendorError) {
                    return Center(
                      child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)),
                    );
                  } else if (state is VendorLoaded) {
                    final vendors = state.vendors;
                    if (vendors.isEmpty) {
                      return Center(child: Text('noVendorsFound'.tr(), style: const TextStyle(color: AppColors.textSecondary)));
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 32,
                          horizontalMargin: 24,
                          headingRowHeight: 48,
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 56,
                          headingRowColor: MaterialStateProperty.all(AppColors.surface),
                          columns: [
                            DataColumn(label: Text('name'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(label: Text('contactPerson'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(label: Text('email'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(label: Text('phone'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(label: Text('status'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(label: Text('actions'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                          ],
                          rows: vendors.map((vendor) {
                            return DataRow(
                              cells: [
                                DataCell(Text(vendor.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                                DataCell(Text(vendor.contactPerson, style: const TextStyle(color: AppColors.textSecondary))),
                                DataCell(Text(vendor.email, style: const TextStyle(color: AppColors.textSecondary))),
                                DataCell(Text(vendor.phone, style: const TextStyle(color: AppColors.textSecondary))),
                                DataCell(_buildStatusChip(vendor.status)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
                                    onPressed: () {},
                                    splashRadius: 20,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Loading vendors...', style: TextStyle(color: AppColors.textSecondary)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;
      case 'inactive':
        bgColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        break;
      case 'pending':
        bgColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
