import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/finance_repository.dart';
import '../../data/model/transaction_model.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final FinanceRepository _repository;

  FinanceCubit(this._repository) : super(const FinanceState());

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(status: FinanceStatus.loading, errorMessage: null));

    final reportResult = await _repository.getReport();
    final transactionsResult = await _repository.getTransactions();

    reportResult.fold(
      (failure) => emit(state.copyWith(
        status: FinanceStatus.error,
        errorMessage: failure.message,
      )),
      (report) {
        transactionsResult.fold(
          (failure) => emit(state.copyWith(
            status: FinanceStatus.error,
            errorMessage: failure.message,
          )),
          (transactions) => emit(state.copyWith(
            status: FinanceStatus.loaded,
            report: report,
            transactions: transactions,
          )),
        );
      },
    );
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    emit(state.copyWith(creationStatus: TransactionCreationStatus.creating, creationErrorMessage: null));

    final result = await _repository.createTransaction(transaction);

    result.fold(
      (failure) => emit(state.copyWith(
        creationStatus: TransactionCreationStatus.error,
        creationErrorMessage: failure.message,
      )),
      (newTransaction) {
        final updatedTransactions = List<TransactionModel>.from(state.transactions)..insert(0, newTransaction);
        emit(state.copyWith(
          creationStatus: TransactionCreationStatus.success,
          transactions: updatedTransactions,
        ));
      },
    );
  }
}
