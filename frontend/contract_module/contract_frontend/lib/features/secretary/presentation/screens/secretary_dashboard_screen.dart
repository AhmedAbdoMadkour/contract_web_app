import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';
import 'package:sasheco_dashboard_web/features/contracts/presentation/cubit/contract_templates_cubit.dart';
import 'package:sasheco_dashboard_web/features/contracts/presentation/cubit/contract_templates_state.dart';
import 'package:sasheco_dashboard_web/features/contracts/data/model/contract_template_model.dart';
import '../cubit/secretary_cubit.dart';
import '../cubit/secretary_state.dart';
import 'package:sasheco_dashboard_web/features/engineering/data/model/contract_model.dart';

class SecretaryDashboardScreen extends StatelessWidget {
  const SecretaryDashboardScreen({super.key});

  Future<void> _pickAndUploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null) {
      final bytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      if (bytes != null && context.mounted) {
        context.read<SecretaryCubit>().uploadDocument(bytes, fileName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<SecretaryCubit, SecretaryState>(
        listener: (context, state) {
          if (state is SecretaryTaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SecretaryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          String title = 'Document Drafting Workspace';
          String subtitle = 'No active task selected';
          List<String> referenceDocs = [];
          
          if (state is SecretaryTasksLoaded && state.tasks.isNotEmpty) {
            final task = state.tasks.first;
            subtitle = 'Contract with ${task.vendorName} - ${task.status}';
            referenceDocs = task.drawings.map((d) => d.fileName).toList();
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ContractModel? currentContract;
                            if (state is SecretaryTasksLoaded && state.tasks.isNotEmpty) {
                              currentContract = state.tasks.first;
                            }
                            _showTemplateSelectionDialog(context, currentContract);
                          },
                          icon: const Icon(Icons.file_download),
                          label: const Text('Import Template', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (state is SecretaryTasksLoaded && state.tasks.isNotEmpty) {
                              final task = state.tasks.first;
                              final terms = context.read<SecretaryCubit>().editorController.text;
                              context.read<SecretaryCubit>().saveDraft(task.id, terms);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No active contract to save.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const ModuleExitButton(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildEditorCard(context),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildReferenceDocsCard(context, referenceDocs),
                              const SizedBox(height: 24),
                              _buildAiSuggestionsCard(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state is SecretaryLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated WYSIWYG Toolbar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}),
                IconButton(icon: const Icon(Icons.format_italic), onPressed: () {}),
                IconButton(icon: const Icon(Icons.format_underline), onPressed: () {}),
                Container(width: 1, height: 24, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
                IconButton(icon: const Icon(Icons.format_align_left), onPressed: () {}),
                IconButton(icon: const Icon(Icons.format_align_center), onPressed: () {}),
                IconButton(icon: const Icon(Icons.format_align_right), onPressed: () {}),
                Container(width: 1, height: 24, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
                IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () {}),
                IconButton(icon: const Icon(Icons.format_list_numbered), onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: context.read<SecretaryCubit>().editorController,
            maxLines: 25,
            decoration: const InputDecoration(
              hintText: 'Start drafting the contract details or import a template...',
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceDocsCard(BuildContext context, List<String> referenceDocs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reference Documents', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              TextButton.icon(
                onPressed: () => _pickAndUploadFile(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Reference'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (referenceDocs.isEmpty)
             const Padding(padding: EdgeInsets.all(8), child: Text("No documents attached.")),
          ...referenceDocs.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildDocItem(doc),
          )),
        ],
      ),
    );
  }

  Widget _buildDocItem(String name) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
          const Icon(Icons.download, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }

  Widget _buildAiSuggestionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('AI Suggestions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Missing Liability Clause', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                SizedBox(height: 4),
                Text('Based on standard templates, you should include a limitation of liability clause.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplateSelectionDialog(BuildContext context, ContractModel? currentContract) {
    // Ensure ContractTemplatesCubit is loaded
    context.read<ContractTemplatesCubit>().loadTemplates();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 600,
            height: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Import Contract Template',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select an Active template to import its contents into the editor.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ContractTemplatesCubit, ContractTemplatesState>(
                    bloc: context.read<ContractTemplatesCubit>(), // Pass the existing cubit
                    builder: (blocContext, state) {
                      if (state is ContractTemplatesLoading || state is ContractTemplatesInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ContractTemplatesLoaded) {
                        final activeTemplates = state.templates.where((t) => t.status == 'Active').toList();

                        if (activeTemplates.isEmpty) {
                          return const Center(child: Text('No active templates available.'));
                        }

                        return ListView.separated(
                          itemCount: activeTemplates.length,
                          separatorBuilder: (_, __) => const Divider(color: AppColors.border),
                          itemBuilder: (listContext, index) {
                            final template = activeTemplates[index];
                            return ListTile(
                              title: Text(template.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${template.items.length} items'),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _injectTemplateIntoEditor(context, template, currentContract);
                                  Navigator.of(dialogContext).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Import'),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('Error loading templates.'));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _injectTemplateIntoEditor(BuildContext context, ContractTemplateModel template, ContractModel? currentContract) {
    final buffer = StringBuffer();
    buffer.writeln('=== ${template.title.toUpperCase()} ===\n');
    
    // Calculate total BOQ amount if contract is provided
    double totalBoq = 0;
    if (currentContract != null) {
      for (var item in currentContract.items) {
        totalBoq += (item.price * item.quantity);
      }
    }

    for (var item in template.items) {
      buffer.writeln('[${item.type.toUpperCase()}] ${item.name}:');
      
      String content = item.content;
      // Replace placeholders
      if (currentContract != null) {
        content = content.replaceAll('{{VendorName}}', currentContract.vendorName);
        content = content.replaceAll('{{BOQ_Total}}', '\$${totalBoq.toStringAsFixed(2)}');
      }
      
      buffer.writeln('$content\n');
    }

    // Append to existing text or replace depending on what makes sense. Let's append with spacing.
    final editorController = context.read<SecretaryCubit>().editorController;
    final currentText = editorController.text;
    if (currentText.trim().isNotEmpty) {
      editorController.text = '$currentText\n\n${buffer.toString()}';
    } else {
      editorController.text = buffer.toString();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported "${template.title}" successfully!')),
    );
  }
}
