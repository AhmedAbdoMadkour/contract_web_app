import 'package:equatable/equatable.dart';
import '../../data/model/finance_report_model.dart';
import '../../data/model/transaction_model.dart';

enum FinanceStatus { initial, loading, loaded, error }
enum TransactionCreationStatus { initial, creating, success, error }

class FinanceState extends Equatable {
  final FinanceStatus status;
  final FinanceReportModel? report;
  final List<TransactionModel> transactions;
  final String? errorMessage;
  
  final TransactionCreationStatus creationStatus;
  final String? creationErrorMessage;

  const FinanceState({
    this.status = FinanceStatus.initial,
    this.report,
    this.transactions = const [],
    this.errorMessage,
    this.creationStatus = TransactionCreationStatus.initial,
    this.creationErrorMessage,
  });

  FinanceState copyWith({
    FinanceStatus? status,
    FinanceReportModel? report,
    List<TransactionModel>? transactions,
    String? errorMessage,
    TransactionCreationStatus? creationStatus,
    String? creationErrorMessage,
  }) {
    return FinanceState(
      status: status ?? this.status,
      report: report ?? this.report,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      creationStatus: creationStatus ?? this.creationStatus,
      creationErrorMessage: creationErrorMessage ?? this.creationErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        report,
        transactions,
        errorMessage,
        creationStatus,
        creationErrorMessage,
      ];
}
