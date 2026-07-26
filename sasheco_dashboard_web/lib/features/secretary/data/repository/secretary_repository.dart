import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/secretary_inbox_item_model.dart';
import '../model/secretary_task_model.dart';
import '../model/create_secretary_task_request.dart';

class SecretaryRepository {
  final NetworkService _networkService;

  SecretaryRepository(this._networkService);

  Future<Either<Failure, List<SecretaryInboxItemModel>>> getInbox() async {
    try {
      final response = await _networkService.get('/api/secretary/inbox');
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final items = data.map((e) => SecretaryInboxItemModel.fromJson(e)).toList();
        return Right(items);
      } else {
        return Left(ServerFailure('Failed to fetch inbox: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, List<SecretaryTaskModel>>> getTasks() async {
    try {
      final response = await _networkService.get('/api/secretary/tasks');
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final tasks = data.map((e) => SecretaryTaskModel.fromJson(e)).toList();
        return Right(tasks);
      } else {
        return Left(ServerFailure('Failed to fetch tasks: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, SecretaryTaskModel>> createTask(CreateSecretaryTaskRequest request) async {
    try {
      final response = await _networkService.post(
        '/api/secretary/tasks',
        data: request.toJson(),
      );
      
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final task = SecretaryTaskModel.fromJson(response.data);
        return Right(task);
      } else {
        return Left(ServerFailure('Failed to create task: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> completeTask(String id) async {
    try {
      final response = await _networkService.put('/api/secretary/tasks/$id/complete');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to complete task: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
