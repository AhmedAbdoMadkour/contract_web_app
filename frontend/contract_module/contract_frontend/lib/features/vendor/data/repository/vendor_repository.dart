import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/vendor_model.dart';
import '../model/create_vendor_model.dart';
import '../model/update_vendor_model.dart';

class VendorRepository {
  final NetworkService _networkService;

  VendorRepository(this._networkService);

  Future<Either<Failure, List<VendorModel>>> getVendors({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _networkService.get(
        '/api/vendor',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      
      final data = response.data as List;
      final vendors = data.map((e) => VendorModel.fromJson(e as Map<String, dynamic>)).toList();
      return Right(vendors);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, VendorModel>> getVendor(String id) async {
    try {
      final response = await _networkService.get('/api/vendor/$id');
      final vendor = VendorModel.fromJson(response.data as Map<String, dynamic>);
      return Right(vendor);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, VendorModel>> createVendor(CreateVendorModel request) async {
    try {
      final response = await _networkService.post('/api/vendor', data: request.toJson());
      final vendor = VendorModel.fromJson(response.data as Map<String, dynamic>);
      return Right(vendor);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> updateVendor(String id, UpdateVendorModel request) async {
    try {
      await _networkService.put('/api/vendor/$id', data: request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> deleteVendor(String id) async {
    try {
      await _networkService.delete('/api/vendor/$id');
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
