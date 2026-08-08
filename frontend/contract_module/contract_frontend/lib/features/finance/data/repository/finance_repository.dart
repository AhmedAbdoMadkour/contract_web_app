import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../model/finance_report_model.dart';
import '../model/transaction_model.dart';

abstract class FinanceRepository {
  Future<Either<Failure, FinanceReportModel>> getReport();
  Future<Either<Failure, List<TransactionModel>>> getTransactions();
  Future<Either<Failure, TransactionModel>> createTransaction(TransactionModel transaction);
}
