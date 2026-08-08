import 'package:dartz/dartz.dart';
import '../../../../core/shared/error/failures.dart';
import '../../../../core/shared/error/error_handler.dart';
import '../../../../core/shared/network/network_service.dart';
import '../model/approval_model.dart';
import '../model/approval_history_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class ApprovalRepository {
  final NetworkService _networkService;

  ApprovalRepository(this._networkService);

  Future<Either<Failure, List<ApprovalModel>>> getApprovals() async {
    try {
      final response = await _networkService.get('/api/approval');
      
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

  Future<Either<Failure, List<ApprovalHistoryModel>>> getApprovalHistory(String id) async {
    try {
      final response = await _networkService.get('/api/approval/$id/history');
      
      if (response.statusCode == 200) {
        final data = response.data as List;
        final history = data.map((e) => ApprovalHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(history);
      } else {
        return const Left(ServerFailure('Failed to fetch approval history.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, bool>> approveApproval(String id, String comments, String? evidenceUrl) async {
    try {
      final response = await _networkService.post(
        '/api/approval/$id/approve',
        data: {
          'comments': comments,
          if (evidenceUrl != null) 'evidenceUrl': evidenceUrl,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else {
        return const Left(ServerFailure('Failed to approve request.'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  Future<Either<Failure, bool>> rejectApproval(String id, String comments, String? evidenceUrl) async {
    try {
      final response = await _networkService.post(
        '/api/approval/$id/reject',
        data: {
          'comments': comments,
          if (evidenceUrl != null) 'evidenceUrl': evidenceUrl,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else {
        return const Left(ServerFailure('Failed to reject request.'));
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
