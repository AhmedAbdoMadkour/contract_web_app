import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../../data/model/contract_template_model.dart';
import '../cubit/contract_templates_cubit.dart';
import 'package:intl/intl.dart';

class TemplateKanbanBoard extends StatelessWidget {
  final List<ContractTemplateModel> templates;

  const TemplateKanbanBoard({super.key, required this.templates});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumn(context, 'Draft', AppColors.textSecondary),
        const SizedBox(width: 24),
        _buildColumn(context, 'Active', AppColors.primary),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, String status, Color color) {
    final columnTemplates = templates.where((t) => t.status == status).toList();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    status,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${columnTemplates.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // Droppable area
            Expanded(
              child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  final templateId = details.data;
                  final template = templates.firstWhere((t) => t.id == templateId);
                  context.read<ContractTemplatesCubit>().updateTemplate(template.copyWith(status: status));
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: candidateData.isNotEmpty ? color.withOpacity(0.05) : Colors.transparent,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: columnTemplates.length,
                      itemBuilder: (context, index) {
                        final template = columnTemplates[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Draggable<String>(
                            data: template.id,
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 300,
                                child: Opacity(opacity: 0.8, child: _TemplateCard(template: template)),
                              ),
                            ),
                            childWhenDragging: Opacity(opacity: 0.3, child: _TemplateCard(template: template)),
                            child: _TemplateCard(template: template),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final ContractTemplateModel template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                template.id,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                onPressed: () {
                  context.read<ContractTemplatesCubit>().deleteTemplate(template.id);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            template.title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.list_alt, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${template.items.length} Items',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              Text(
                DateFormat('MMM d, yyyy').format(template.createdAt),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
