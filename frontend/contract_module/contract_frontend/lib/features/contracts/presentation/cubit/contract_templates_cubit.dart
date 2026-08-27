import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/contract_template_model.dart';
import '../../data/repository/contracts_repository.dart';
import 'contract_templates_state.dart';

class ContractTemplatesCubit extends Cubit<ContractTemplatesState> {
  final ContractsRepository _contractsRepository;
  
  ContractTemplatesCubit(this._contractsRepository) : super(ContractTemplatesInitial());

  Future<void> loadTemplates() async {
    emit(ContractTemplatesLoading());
    try {
      final templates = await _contractsRepository.getTemplates();
      emit(ContractTemplatesLoaded(templates: templates));
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  Future<void> addTemplate(ContractTemplateModel template) async {
    try {
      await _contractsRepository.createTemplate(template);
      emit(ContractTemplatesOperationSuccess('Template created successfully'));
      loadTemplates();
    } catch (e) {
      emit(ContractTemplatesError(e.toString()));
    }
  }

  void updateTemplate(ContractTemplateModel template) {
    // Left empty for now, or you can implement it using repository if needed
    // The current instruction just says create via POST /api/templates
  }

  void deleteTemplate(String id) {
    // Same as above
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
