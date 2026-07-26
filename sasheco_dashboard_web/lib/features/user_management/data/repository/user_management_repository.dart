import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/user_model.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<UserModel>>> getUsers();
  Future<Either<Failure, UserModel>> getUser(String id);
  Future<Either<Failure, UserModel>> createUser(UserModel user);
  Future<Either<Failure, UserModel>> updateUser(UserModel user);
  Future<Either<Failure, void>> deleteUser(String id);
}

class UserManagementRepositoryImpl implements UserManagementRepository {
  final NetworkService _networkService;

  UserManagementRepositoryImpl(this._networkService);

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    try {
      final response = await _networkService.get('/api/users');
      final List<dynamic> data = response.data;
      final users = data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
      return Right(users);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String id) async {
    try {
      final response = await _networkService.get('/api/users/$id');
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUser(UserModel user) async {
    try {
      final response = await _networkService.post('/api/users', data: user.toJson());
      final newUser = UserModel.fromJson(response.data as Map<String, dynamic>);
      return Right(newUser);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    try {
      final response = await _networkService.put('/api/users/${user.id}', data: user.toJson());
      final updatedUser = UserModel.fromJson(response.data as Map<String, dynamic>);
      return Right(updatedUser);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _networkService.delete('/api/users/$id');
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
