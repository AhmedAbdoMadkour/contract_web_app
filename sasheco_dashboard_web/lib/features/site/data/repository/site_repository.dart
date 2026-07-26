import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/site_model.dart';

abstract class SiteRepository {
  Future<Either<Failure, SiteModel>> getSiteDashboard();
  Future<Either<Failure, void>> updateSiteLocation(String siteId, double lat, double lng);
}

class SiteRepositoryImpl implements SiteRepository {
  final NetworkService networkService;

  SiteRepositoryImpl({required this.networkService});

  @override
  Future<Either<Failure, SiteModel>> getSiteDashboard() async {
    try {
      final response = await networkService.get('/api/site/dashboard');
      if (response.statusCode == 200) {
        final siteModel = SiteModel.fromJson(response.data);
        return Right(siteModel);
      } else {
        return const Left(ServerFailure('Failed to load site data.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateSiteLocation(String siteId, double lat, double lng) async {
    try {
      await networkService.put('/api/site/$siteId/location', data: {
        'latitude': lat,
        'longitude': lng,
      });
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
