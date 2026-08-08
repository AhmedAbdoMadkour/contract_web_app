import 'package:equatable/equatable.dart';
import '../../data/model/contract_template_model.dart';

abstract class ContractTemplatesState extends Equatable {
  const ContractTemplatesState();

  @override
  List<Object?> get props => [];
}

class ContractTemplatesInitial extends ContractTemplatesState {}

class ContractTemplatesLoading extends ContractTemplatesState {}

class ContractTemplatesLoaded extends ContractTemplatesState {
  final List<ContractTemplateModel> templates;
  final bool isKanbanView;
  final String searchQuery;
  final String statusFilter;

  const ContractTemplatesLoaded({
    required this.templates,
    this.isKanbanView = true,
    this.searchQuery = '',
    this.statusFilter = 'All',
  });

  ContractTemplatesLoaded copyWith({
    List<ContractTemplateModel>? templates,
    bool? isKanbanView,
    String? searchQuery,
    String? statusFilter,
  }) {
    return ContractTemplatesLoaded(
      templates: templates ?? this.templates,
      isKanbanView: isKanbanView ?? this.isKanbanView,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  @override
  List<Object?> get props => [templates, isKanbanView, searchQuery, statusFilter];
}

class ContractTemplatesError extends ContractTemplatesState {
  final String message;

  const ContractTemplatesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractTemplatesOperationSuccess extends ContractTemplatesState {
  final String message;
  
  const ContractTemplatesOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
