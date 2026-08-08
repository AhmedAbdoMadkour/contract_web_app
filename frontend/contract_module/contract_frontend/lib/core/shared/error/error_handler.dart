import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractMessage(error.response?.data);
        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedFailure(message ?? 'Unauthorized access.');
        } else if (statusCode == 400 || statusCode == 422) {
          return InvalidInputFailure(message ?? 'Invalid input data.');
        } else if (statusCode != null && statusCode >= 500) {
          return const ServerFailure('Internal server error. Please try again later.');
        } else {
          return ServerFailure(message ?? 'Something went wrong.');
        }
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection.');
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      default:
        return const ServerFailure('An unknown error occurred.');
    }
  }

  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return handleDioError(error);
    }
    return const ServerFailure('An unexpected error occurred.');
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'] as String;
    }
    return null;
  }
}
