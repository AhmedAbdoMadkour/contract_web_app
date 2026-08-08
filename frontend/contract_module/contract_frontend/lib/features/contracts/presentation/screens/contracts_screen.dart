import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../widgets/kanban_board.dart';
import '../widgets/list_board.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFilterRow(context),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ContractsCubit, ContractsState>(
                builder: (context, state) {
                  if (state is ContractsLoading || state is ContractsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContractsError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  } else if (state is ContractsLoaded) {
                    final filteredContracts = state.contracts.where((c) {
                      final matchesSearch = c.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
                                            c.clientName.toLowerCase().contains(state.searchQuery.toLowerCase());
                      final matchesFilter = state.statusFilter == 'All' || c.status == state.statusFilter;
                      return matchesSearch && matchesFilter;
                    }).toList();
                    
                    return state.isKanbanView 
                        ? KanbanBoard(contracts: filteredContracts)
                        : ListBoard(contracts: filteredContracts);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contracts Review',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upcoming team timetable & member access directory',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildMetricItem('13k+', 'Total quantity\ncontracts'),
            const SizedBox(width: 24),
            _buildMetricItem('85%', 'Total value\ncontracts'),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New Contract'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(width: 16),
            const ModuleExitButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                onChanged: (value) => context.read<ContractsCubit>().setSearchQuery(value),
                decoration: const InputDecoration(
                  hintText: 'Search contracts...',
                  hintStyle: TextStyle(color: AppColors.textDisabled, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildFilterButton(context, 'All'),
            const SizedBox(width: 8),
            _buildFilterButton(context, 'Draft'),
            const SizedBox(width: 8),
            _buildFilterButton(context, 'Active'),
            const SizedBox(width: 8),
            _buildFilterButton(context, 'Completed'),
            const SizedBox(width: 8),
            _buildFilterButton(context, 'Terminated'),
          ],
        ),
        BlocBuilder<ContractsCubit, ContractsState>(
          builder: (context, state) {
            bool isKanban = true;
            if (state is ContractsLoaded) {
              isKanban = state.isKanbanView;
            }
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildViewToggleButton(
                    title: 'Kanban View',
                    isActive: isKanban,
                    onTap: () {
                      if (!isKanban) context.read<ContractsCubit>().toggleView();
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildViewToggleButton(
                    title: 'List View',
                    isActive: !isKanban,
                    onTap: () {
                      if (isKanban) context.read<ContractsCubit>().toggleView();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, String title) {
    return BlocBuilder<ContractsCubit, ContractsState>(
      builder: (context, state) {
        bool isActive = false;
        if (state is ContractsLoaded) {
          isActive = state.statusFilter == title;
        }
        return InkWell(
          onTap: () => context.read<ContractsCubit>().setStatusFilter(title),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF3F0FF) : Colors.transparent, // light purple active
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? const Color(0xFF6B4EFF) : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildViewToggleButton({required String title, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
