import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../../data/model/contract_template_model.dart';
import '../cubit/contract_templates_cubit.dart';
import 'package:intl/intl.dart';

class TemplateListBoard extends StatelessWidget {
  final List<ContractTemplateModel> templates;

  const TemplateListBoard({super.key, required this.templates});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        separatorBuilder: (context, index) => const Divider(color: AppColors.border),
        itemBuilder: (context, index) {
          final template = templates[index];
          return ListTile(
            title: Text(
              template.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Text(
              '${template.id} • ${template.items.length} Items • Created ${DateFormat('MMM d, yyyy').format(template.createdAt)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: template.status == 'Active' ? AppColors.primary.withOpacity(0.1) : AppColors.textDisabled.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    template.status,
                    style: TextStyle(
                      color: template.status == 'Active' ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    context.read<ContractTemplatesCubit>().deleteTemplate(template.id);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
