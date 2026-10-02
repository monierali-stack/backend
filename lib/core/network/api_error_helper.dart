import 'package:dio/dio.dart';

class ApiErrorHelper {
  // TODO: tighten this once we see real error responses from the API —
  // for now it tries the common shapes (message/error/msg/detail, or a
  // plain string body) and falls back to the HTTP status/DioException type.
  static String messageFrom(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final msg = data['message'] ?? data['error'] ?? data['msg'] ?? data['detail'];
        if (msg is String && msg.isNotEmpty) return msg;
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          final first = errors.values.isNotEmpty ? errors.values.first : null;
          if (first is List && first.isNotEmpty) return first.first.toString();
          if (first != null) return first.toString();
        }
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          final status = error.response?.statusCode;
          if (status == 401) return 'Invalid credentials.';
          if (status == 404) return 'Not found.';
          return 'Something went wrong (${status ?? 'network error'}).';
      }
    }
    return error.toString();
  }
}
