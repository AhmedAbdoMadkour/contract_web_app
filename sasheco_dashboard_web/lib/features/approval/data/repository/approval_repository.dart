import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/approval_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class ApprovalRepository {
  final NetworkService _networkService;

  ApprovalRepository(this._networkService);

  Future<Either<Failure, List<ApprovalModel>>> getApprovals() async {
    try {
      final response = await _networkService.get('/api/approvals');
      
      if (response.statusCode == 200) {
        final data = response.data as List;
        final approvals = data.map((e) => ApprovalModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(approvals);
      } else {
        return const Left(ServerFailure('Failed to fetch approvals.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, bool>> updateApprovalStatus(String id, String status) async {
    try {
      final response = await _networkService.put(
        '/api/approvals/$id/status',
        data: {'status': status},
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else {
        return const Left(ServerFailure('Failed to update approval status.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, String>> uploadDocument(PlatformFile file) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          file.bytes ?? [],
          filename: file.name,
        ),
      });

      final response = await _networkService.post(
        '/api/approvals/upload',
        data: formData,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['url'] ?? '');
      } else {
        return const Left(ServerFailure('Failed to upload document.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
