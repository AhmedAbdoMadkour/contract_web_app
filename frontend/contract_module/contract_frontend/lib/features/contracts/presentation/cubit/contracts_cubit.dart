import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/contracts_repository.dart';
import 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final ContractsRepository repository;

  ContractsCubit(this.repository) : super(ContractsInitial());

  Future<void> loadContracts() async {
    emit(ContractsLoading());
    try {
      final contracts = await repository.getContracts();
      emit(ContractsLoaded(contracts: contracts));
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }

  void toggleView() {
    if (state is ContractsLoaded) {
      final currentState = state as ContractsLoaded;
      emit(currentState.copyWith(isKanbanView: !currentState.isKanbanView));
    }
  }

  void setSearchQuery(String query) {
    if (state is ContractsLoaded) {
      final currentState = state as ContractsLoaded;
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void setStatusFilter(String filter) {
    if (state is ContractsLoaded) {
      final currentState = state as ContractsLoaded;
      emit(currentState.copyWith(statusFilter: filter));
    }
  }

  Future<void> updateContractStatus(String id, String newStatus) async {
    if (state is ContractsLoaded) {
      final currentState = state as ContractsLoaded;
      
      // Optimistic update
      final updatedContracts = currentState.contracts.map((c) {
        if (c.id == id) {
          return c.copyWith(status: newStatus);
        }
        return c;
      }).toList();
      
      emit(currentState.copyWith(contracts: updatedContracts));
      
      try {
        await repository.updateContractStatus(id, newStatus);
      } catch (e) {
        // Fallback or ignore for mock
      }
    }
  }

  Future<void> createContract(String projectId, String vendorId, String termsAndConditions) async {
    try {
      // Show loading maybe, but for simplicity just await and reload
      await repository.createContract(projectId, vendorId, termsAndConditions);
      await loadContracts();
    } catch (e) {
      emit(ContractsError(e.toString()));
    }
  }
}
