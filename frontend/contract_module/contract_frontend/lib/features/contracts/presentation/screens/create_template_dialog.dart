import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../../data/model/contract_template_model.dart';
import '../cubit/contract_templates_cubit.dart';
import 'dart:math';

class CreateTemplateDialog extends StatefulWidget {
  const CreateTemplateDialog({super.key});

  @override
  State<CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends State<CreateTemplateDialog> {
  final _titleController = TextEditingController();
  final List<_TemplateItemForm> _items = [];

  @override
  void initState() {
    super.initState();
    _addItem(); // Start with one item by default
  }

  void _addItem() {
    setState(() {
      _items.add(_TemplateItemForm(
        id: 'i${Random().nextInt(10000)}',
        typeController: TextEditingController(),
        nameController: TextEditingController(),
        contentController: TextEditingController(),
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _saveTemplate() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a template title')));
      return;
    }

    final newItems = _items.map((item) {
      return TemplateItemModel(
        id: item.id,
        type: item.typeController.text.trim(),
        name: item.nameController.text.trim(),
        content: item.contentController.text.trim(),
      );
    }).toList();

    final newTemplate = ContractTemplateModel(
      id: 'TPL-${Random().nextInt(9999).toString().padLeft(4, '0')}',
      title: _titleController.text.trim(),
      status: 'Draft',
      items: newItems,
      createdAt: DateTime.now(),
    );

    context.read<ContractTemplatesCubit>().addTemplate(newTemplate);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var item in _items) {
      item.typeController.dispose();
      item.nameController.dispose();
      item.contentController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Contract Template',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Template Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Template Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(index);
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveTemplate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Template'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int index) {
    final item = _items[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Item #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const Spacer(),
                if (_items.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () => _removeItem(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: item.typeController,
                    decoration: InputDecoration(
                      labelText: 'Item Type (e.g. Header, Clause)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: item.nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name / Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: item.contentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Item Content',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateItemForm {
  final String id;
  final TextEditingController typeController;
  final TextEditingController nameController;
  final TextEditingController contentController;

  _TemplateItemForm({
    required this.id,
    required this.typeController,
    required this.nameController,
    required this.contentController,
  });
}
