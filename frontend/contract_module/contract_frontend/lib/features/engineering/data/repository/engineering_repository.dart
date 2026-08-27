import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/engineering_project_model.dart';
import '../model/contract_model.dart';

class EngineeringRepository {
  final NetworkService _networkService;

  EngineeringRepository(this._networkService);

  Future<Either<Failure, List<EngineeringProjectModel>>> getProjects() async {
    try {
      final response = await _networkService.get('/api/Engineering/projects');
      final List<dynamic> data = response.data;
      final projects = data.map((json) => EngineeringProjectModel.fromJson(json as Map<String, dynamic>)).toList();
      return Right(projects);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, EngineeringProjectModel>> getProject(String id) async {
    try {
      final response = await _networkService.get('/api/Engineering/projects/$id');
      final project = EngineeringProjectModel.fromJson(response.data as Map<String, dynamic>);
      return Right(project);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, EngineeringProjectModel>> createProject({
    required String name,
    required String description,
    required DateTime startDate,
  }) async {
    try {
      final response = await _networkService.post(
        '/api/Engineering/projects',
        data: {
          'name': name,
          'description': description,
          'startDate': startDate.toIso8601String(),
        },
      );
      final project = EngineeringProjectModel.fromJson(response.data as Map<String, dynamic>);
      return Right(project);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  Future<Either<Failure, void>> updateProjectStatus(String id, String status) async {
    try {
      await _networkService.put(
        '/api/Engineering/projects/$id/status',
        data: {
          'status': status,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, List<ContractModel>>> getProjectContracts(String id) async {
    try {
      final response = await _networkService.get('/api/Engineering/projects/$id/contracts');
      final List<dynamic> data = response.data;
      final contracts = data.map((json) => ContractModel.fromJson(json as Map<String, dynamic>)).toList();
      return Right(contracts);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> addContractItem({
    required String contractId,
    required double price,
    required int quantity,
    required String descriptionEn,
    required String descriptionAr,
  }) async {
    try {
      await _networkService.post(
        '/api/contracts/$contractId/items',
        data: {
          'price': price,
          'quantity': quantity,
          'descriptionEn': descriptionEn,
          'descriptionAr': descriptionAr,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> uploadDrawing({
    required String contractId,
    required dynamic fileBytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      await _networkService.post(
        '/api/contracts/$contractId/drawings',
        data: formData,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> uploadBulkItems({
    required String contractId,
    required dynamic fileBytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      await _networkService.post(
        '/api/contracts/$contractId/items/bulk',
        data: formData,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> submitContract(String contractId, String paymentTerms) async {
    try {
      await _networkService.put(
        '/api/Engineering/$contractId/submit',
        data: {
          'paymentTerms': paymentTerms,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
