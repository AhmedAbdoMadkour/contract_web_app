import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/contract_template_model.dart';
import 'contract_templates_state.dart';

class ContractTemplatesCubit extends Cubit<ContractTemplatesState> {
  ContractTemplatesCubit() : super(ContractTemplatesInitial());

  // In-memory storage for demonstration purposes.
  // In a real app, this would be injected via a Repository.
  final List<ContractTemplateModel> _mockTemplates = [
    ContractTemplateModel(
      id: 'TPL-001',
      title: 'Standard Supply & Install',
      status: 'Active',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      items: [
        TemplateItemModel(id: 'i1', type: 'Header', name: '1', content: 'Supply and installation of wood cladding'),
        TemplateItemModel(id: 'i2', type: 'Clause', name: '2', content: 'The first party agrees to execute the works...'),
      ],
    ),
    ContractTemplateModel(
      id: 'TPL-002',
      title: 'Consulting Services Agreement',
      status: 'Draft',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      items: [
        TemplateItemModel(id: 'i1', type: 'Header', name: '1', content: 'Scope of Services'),
      ],
    ),
  ];

  void loadTemplates() {
    emit(ContractTemplatesLoading());
    try {
      // Simulate network delay
      Future.delayed(const Duration(milliseconds: 600), () {
        emit(ContractTemplatesLoaded(templates: List.from(_mockTemplates)));
      });
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  void addTemplate(ContractTemplateModel template) {
    try {
      _mockTemplates.add(template);
      final currentState = state;
      if (currentState is ContractTemplatesLoaded) {
        emit(ContractTemplatesOperationSuccess('Template created successfully'));
        emit(currentState.copyWith(templates: List.from(_mockTemplates)));
      } else {
        loadTemplates();
      }
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  void updateTemplate(ContractTemplateModel template) {
    try {
      final index = _mockTemplates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        _mockTemplates[index] = template;
        final currentState = state;
        if (currentState is ContractTemplatesLoaded) {
          emit(ContractTemplatesOperationSuccess('Template updated successfully'));
          emit(currentState.copyWith(templates: List.from(_mockTemplates)));
        } else {
          loadTemplates();
        }
      }
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  void deleteTemplate(String id) {
    try {
      _mockTemplates.removeWhere((t) => t.id == id);
      final currentState = state;
      if (currentState is ContractTemplatesLoaded) {
        emit(ContractTemplatesOperationSuccess('Template deleted successfully'));
        emit(currentState.copyWith(templates: List.from(_mockTemplates)));
      }
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  void toggleViewMode() {
    final currentState = state;
    if (currentState is ContractTemplatesLoaded) {
      emit(currentState.copyWith(isKanbanView: !currentState.isKanbanView));
    }
  }

  void setSearchQuery(String query) {
    final currentState = state;
    if (currentState is ContractTemplatesLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void setStatusFilter(String status) {
    final currentState = state;
    if (currentState is ContractTemplatesLoaded) {
      emit(currentState.copyWith(statusFilter: status));
    }
  }
}
