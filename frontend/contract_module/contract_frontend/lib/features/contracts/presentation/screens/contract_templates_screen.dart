import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';
import '../cubit/contract_templates_cubit.dart';
import '../cubit/contract_templates_state.dart';
import '../widgets/template_kanban_board.dart';
import '../widgets/template_list_board.dart';
import 'create_template_dialog.dart';

class ContractTemplatesScreen extends StatelessWidget {
  const ContractTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildFilterRow(context),
            const SizedBox(height: 24),
            Expanded(
              child: BlocConsumer<ContractTemplatesCubit, ContractTemplatesState>(
                listener: (context, state) {
                  if (state is ContractTemplatesOperationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is ContractTemplatesError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.red))),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ContractTemplatesLoading || state is ContractTemplatesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContractTemplatesLoaded) {
                    final filteredTemplates = state.templates.where((t) {
                      final matchesSearch = t.title.toLowerCase().contains(state.searchQuery.toLowerCase());
                      final matchesFilter = state.statusFilter == 'All' || t.status == state.statusFilter;
                      return matchesSearch && matchesFilter;
                    }).toList();
                    
                    return state.isKanbanView 
                        ? TemplateKanbanBoard(templates: filteredTemplates)
                        : TemplateListBoard(templates: filteredTemplates);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contract Templates',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage and create contract templates for repeated use',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ContractTemplatesCubit>(),
                    child: const CreateTemplateDialog(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Template'),
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
                onChanged: (value) => context.read<ContractTemplatesCubit>().setSearchQuery(value),
                decoration: const InputDecoration(
                  hintText: 'Search templates...',
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
          ],
        ),
        BlocBuilder<ContractTemplatesCubit, ContractTemplatesState>(
          builder: (context, state) {
            bool isKanban = true;
            if (state is ContractTemplatesLoaded) {
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
                      if (!isKanban) context.read<ContractTemplatesCubit>().toggleViewMode();
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildViewToggleButton(
                    title: 'List View',
                    isActive: !isKanban,
                    onTap: () {
                      if (isKanban) context.read<ContractTemplatesCubit>().toggleViewMode();
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

  Widget _buildFilterButton(BuildContext context, String text) {
    return BlocBuilder<ContractTemplatesCubit, ContractTemplatesState>(
      builder: (context, state) {
        bool isSelected = false;
        if (state is ContractTemplatesLoaded) {
          isSelected = state.statusFilter == text;
        }

        return InkWell(
          onTap: () => context.read<ContractTemplatesCubit>().setStatusFilter(text),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewToggleButton({required String title, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
