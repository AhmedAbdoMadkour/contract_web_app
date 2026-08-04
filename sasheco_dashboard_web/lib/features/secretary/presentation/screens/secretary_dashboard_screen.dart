import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/secretary_cubit.dart';
import '../cubit/secretary_state.dart';

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
                              'Document Drafting Workspace',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Alpha Terminal Expansion - Main Contract',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.save),
                          label: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
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
                              _buildReferenceDocsCard(context),
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
          const TextField(
            maxLines: 25,
            decoration: InputDecoration(
              hintText: 'Start drafting the contract details...',
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceDocsCard(BuildContext context) {
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
          _buildDocItem('Engineering Specs.pdf'),
          const SizedBox(height: 8),
          _buildDocItem('Standard Terms.docx'),
          const SizedBox(height: 8),
          _buildDocItem('Vendor Agreement.pdf'),
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
}
