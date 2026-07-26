import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/user_model.dart';
import '../model/login_request_model.dart';

class AuthRepository {
  final NetworkService _networkService;

  AuthRepository(this._networkService);

  Future<Either<Failure, UserModel>> login(LoginRequestModel request) async {
    try {
      final response = await _networkService.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data);
        return Right(user);
      } else {
        return Left(ServerFailure('Failed to authenticate: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
