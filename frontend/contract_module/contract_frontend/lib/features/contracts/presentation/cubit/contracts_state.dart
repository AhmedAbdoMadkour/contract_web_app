import '../../data/model/contract_model.dart';

abstract class ContractsState {}

class ContractsInitial extends ContractsState {}

class ContractsLoading extends ContractsState {}

class ContractsLoaded extends ContractsState {
  final List<ContractModel> contracts;
  final bool isKanbanView;
  final String searchQuery;
  final String statusFilter;

  ContractsLoaded({
    required this.contracts, 
    this.isKanbanView = true,
    this.searchQuery = '',
    this.statusFilter = 'All',
  });

  ContractsLoaded copyWith({
    List<ContractModel>? contracts,
    bool? isKanbanView,
    String? searchQuery,
    String? statusFilter,
  }) {
    return ContractsLoaded(
      contracts: contracts ?? this.contracts,
      isKanbanView: isKanbanView ?? this.isKanbanView,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class ContractsError extends ContractsState {
  final String message;
  ContractsError(this.message);
}
