import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TemplateItemForm {
  final String id;
  final TextEditingController typeController;
  final TextEditingController nameController;
  final TextEditingController contentController;

  TemplateItemForm({
    required this.id,
    required this.typeController,
    required this.nameController,
    required this.contentController,
  });

  void dispose() {
    typeController.dispose();
    nameController.dispose();
    contentController.dispose();
  }
}

class CreateTemplateFormState {
  final List<TemplateItemForm> items;
  final int updateTrigger; // to force rebuilds when items are added/removed

  CreateTemplateFormState({required this.items, this.updateTrigger = 0});

  CreateTemplateFormState copyWith({List<TemplateItemForm>? items, int? updateTrigger}) {
    return CreateTemplateFormState(
      items: items ?? this.items,
      updateTrigger: updateTrigger ?? this.updateTrigger,
    );
  }
}

class CreateTemplateFormCubit extends Cubit<CreateTemplateFormState> {
  final TextEditingController titleController = TextEditingController();

  CreateTemplateFormCubit() : super(CreateTemplateFormState(items: [])) {
    addItem();
  }

  void addItem() {
    final newItem = TemplateItemForm(
      id: '',
      typeController: TextEditingController(),
      nameController: TextEditingController(),
      contentController: TextEditingController(),
    );
    final newItems = List<TemplateItemForm>.from(state.items)..add(newItem);
    emit(state.copyWith(items: newItems, updateTrigger: state.updateTrigger + 1));
  }

  void removeItem(int index) {
    if (index >= 0 && index < state.items.length) {
      final item = state.items[index];
      item.dispose();
      final newItems = List<TemplateItemForm>.from(state.items)..removeAt(index);
      emit(state.copyWith(items: newItems, updateTrigger: state.updateTrigger + 1));
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    for (var item in state.items) {
      item.dispose();
    }
    return super.close();
  }
}
