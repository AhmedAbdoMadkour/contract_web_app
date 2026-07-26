import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/dashboard_metrics_model.dart';

class DashboardRepository {
  final NetworkService _networkService;

  DashboardRepository(this._networkService);

  Future<Either<Failure, DashboardMetricsModel>> getDashboardMetrics() async {
    try {
      final response = await _networkService.get('/api/dashboard');
      
      if (response.statusCode == 200) {
        final model = DashboardMetricsModel.fromJson(response.data);
        return Right(model);
      } else {
        return Left(ServerFailure(response.statusMessage ?? 'Failed to load metrics'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
