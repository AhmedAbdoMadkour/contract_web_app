import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../../data/model/document_template_model.dart';
import '../cubit/secretarial_drafting_cubit.dart';
import '../cubit/secretarial_drafting_state.dart';

class SecretarialDraftingScreen extends StatefulWidget {
  const SecretarialDraftingScreen({super.key});

  @override
  State<SecretarialDraftingScreen> createState() => _SecretarialDraftingScreenState();
}

class _SecretarialDraftingScreenState extends State<SecretarialDraftingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SecretarialDraftingCubit>().loadTemplates();
  }

  void _showPdfDownloadedDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Generated Successfully'),
        content: Text('Your document has been prepared.\n\nLink: $url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<SecretarialDraftingCubit, SecretarialDraftingState>(
        listener: (context, state) {
          if (state is SecretarialDraftingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is SecretarialDraftingLoaded && state.pdfUrl != null) {
            _showPdfDownloadedDialog(state.pdfUrl!);
          }
        },
        builder: (context, state) {
          if (state is SecretarialDraftingInitial || state is SecretarialDraftingLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is SecretarialDraftingLoaded) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secretarial Drafting',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a template and choose clauses to generate a document',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Panel: Template & Clauses
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: AppColors.surface,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '1. Select Template',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTemplateDropdown(context, state),
                                  const SizedBox(height: 24),
                                  const Text(
                                    '2. Select Clauses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(child: _buildClausesList(context, state)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Panel: Preview
                        Expanded(
                          flex: 2,
                          child: Card(
                            color: AppColors.surface,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '3. Document Preview',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              context.read<SecretarialDraftingCubit>().previewDocument();
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: AppColors.primary,
                                              side: const BorderSide(color: AppColors.primary),
                                            ),
                                            child: const Text('Preview Clauses'),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton(
                                            onPressed: state.isGeneratingPdf || state.previewText.isEmpty
                                                ? null
                                                : () {
                                                    context.read<SecretarialDraftingCubit>().generatePdf();
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: state.isGeneratingPdf
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text('Generate PDF'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: state.previewText.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'Click "Preview Clauses" to generate document preview',
                                                style: TextStyle(color: AppColors.textDisabled),
                                              ),
                                            )
                                          : Markdown(
                                              data: state.previewText,
                                              padding: EdgeInsets.zero,
                                              selectable: true,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTemplateDropdown(BuildContext context, SecretarialDraftingLoaded state) {
    if (state.templates.isEmpty) {
      return const Text('No templates available.');
    }
    return DropdownButtonFormField<DocumentTemplateModel>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      isExpanded: true,
      hint: const Text('Select a template...'),
      value: state.selectedTemplate,
      items: state.templates.map((t) {
        return DropdownMenuItem<DocumentTemplateModel>(
          value: t,
          child: Text(t.name),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          context.read<SecretarialDraftingCubit>().selectTemplate(val);
        }
      },
    );
  }

  Widget _buildClausesList(BuildContext context, SecretarialDraftingLoaded state) {
    if (state.selectedTemplate == null) {
      return const Center(
        child: Text(
          'Please select a template first.',
          style: TextStyle(color: AppColors.textDisabled),
        ),
      );
    }

    final clauses = state.selectedTemplate!.clauses;
    if (clauses.isEmpty) {
      return const Text('No clauses in this template.');
    }

    return ListView.builder(
      itemCount: clauses.length,
      itemBuilder: (context, index) {
        final clause = clauses[index];
        final isSelected = state.selectedClauseIds.contains(clause.id);

        return CheckboxListTile(
          title: Text(
            clause.title,
            style: TextStyle(
              fontWeight: clause.isMandatory ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            clause.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          value: isSelected,
          activeColor: AppColors.primary,
          onChanged: clause.isMandatory
              ? null // Mandatory clauses cannot be unchecked
              : (val) {
                  if (val != null) {
                    context.read<SecretarialDraftingCubit>().toggleClause(clause.id, val);
                  }
                },
        );
      },
    );
  }
}
