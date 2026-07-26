import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/finance_report_model.dart';
import '../model/transaction_model.dart';
import 'finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final NetworkService _networkService;

  FinanceRepositoryImpl(this._networkService);

  @override
  Future<Either<Failure, FinanceReportModel>> getReport() async {
    try {
      final response = await _networkService.get('/api/Finance/report');
      final data = FinanceReportModel.fromJson(response.data);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions() async {
    try {
      final response = await _networkService.get('/api/Finance/transactions');
      final data = (response.data as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList();
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> createTransaction(TransactionModel transaction) async {
    try {
      final response = await _networkService.post(
        '/api/Finance/transactions',
        data: transaction.toJson(),
      );
      final data = TransactionModel.fromJson(response.data);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
