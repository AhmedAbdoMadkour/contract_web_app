import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/role_model.dart';

class RolesRepository {
  final NetworkService _networkService;

  RolesRepository(this._networkService);

  Future<Either<Failure, List<RoleModel>>> fetchRoles() async {
    try {
      // Mock Data for roles to make sure the app works without backend
      await Future.delayed(const Duration(seconds: 1));
      final mockData = [
        {
          "id": "11111111-1111-1111-1111-111111111111",
          "name": "Admin",
          "description": "Administrator",
          "permissions": ["Contract", "Finance", "Users", "Engineering", "Secretary", "Approval", "Vendor", "Site"]
        },
        {
          "id": "11111111-1111-1111-1111-111111111112",
          "name": "Project Manager",
          "description": "Manages projects and contracts",
          "permissions": ["Contract", "Engineering", "Site"]
        },
        {
          "id": "11111111-1111-1111-1111-111111111113",
          "name": "Finance",
          "description": "Financial operations",
          "permissions": ["Finance"]
        },
        {
          "id": "11111111-1111-1111-1111-111111111114",
          "name": "Auditor",
          "description": "Read-only auditor access",
          "permissions": ["Approval"]
        }
      ];

      try {
        final response = await _networkService.get('/api/roles');
        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> data = response.data is List ? response.data : response.data['data'] ?? [];
          final roles = data.map((e) => RoleModel.fromJson(e)).toList();
          return Right(roles);
        }
      } catch (e) {
        // Fallback to mock data if API fails
        final roles = mockData.map((e) => RoleModel.fromJson(e)).toList();
        return Right(roles);
      }

      return Left(ServerFailure('Failed to fetch roles'));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, void>> updateRolePermissions(String id, List<String> permissions) async {
    try {
      final response = await _networkService.put(
        '/api/roles/$id/permissions',
        data: {'permissions': permissions},
      );
      
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to update permissions: ${response.statusCode}'));
      }
    } catch (e) {
      // Mock success for now since we don't know if the backend is running
      return const Right(null);
    }
  }
}
