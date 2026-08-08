import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../error/failures.dart';
import '../error/error_handler.dart';
import '../network/network_service.dart';

class DocumentUploadService {
  final NetworkService _networkService;

  DocumentUploadService(this._networkService);

  Future<Either<Failure, String>> uploadDocument(PlatformFile file, {String? targetEndpoint}) async {
    try {
      final endpoint = targetEndpoint ?? '/api/documents/upload';
      
      // Use bytes for web support, fallback to path for mobile
      final multipartFile = file.bytes != null 
          ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
          : await MultipartFile.fromFile(file.path!, filename: file.name);

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await _networkService.post(
        endpoint,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assume API returns URL or ID of uploaded document
        final result = response.data['url'] ?? response.data['id'] ?? 'Upload successful';
        return Right(result.toString());
      } else {
        return Left(ServerFailure('Upload failed with status: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
