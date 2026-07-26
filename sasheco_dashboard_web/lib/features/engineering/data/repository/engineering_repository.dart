import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/engineering_project_model.dart';

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
}
