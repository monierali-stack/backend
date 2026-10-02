import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/core/network/api_constants.dart';
import 'package:shop/core/network/token_storage.dart';

// Custom Dio option key used to force a specific request to send the
// refresh_token instead of the access_token (see get_user_data below).
const _forceRefreshTokenKey = 'force_refresh_token';

class DioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // Separate instance (no interceptors) so refreshing the token doesn't
  // recursively trigger the 401 handler below.
  static final Dio _plainDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;

    if (kDebugMode) {
      _dio.interceptors.add(_LoggingInterceptor());
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // CONFIRMED from the Postman collection's saved example
          // tokens (decoded JWTs): every normal protected route
          // ("type":"access" in the token payload) expects the
          // access_token — standard JWT practice. Only the literal
          // /refresh_token endpoint expects the refresh_token.
          final forceRefresh = options.extra[_forceRefreshTokenKey] == true;
          final token = forceRefresh
              ? await TokenStorage.getRefreshToken()
              : await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          // On an expired access token, try refreshing once and
          // replaying the original request before giving up.
          final alreadyRetried = error.requestOptions.extra['retried'] == true;
          if (error.response?.statusCode == 401 && !alreadyRetried) {
            final refreshed = await _tryRefreshAccessToken();
            if (refreshed != null) {
              final req = error.requestOptions;
              req.headers['Authorization'] = 'Bearer $refreshed';
              req.extra['retried'] = true;
              try {
                final retryResponse = await _dio.fetch(req);
                return handler.resolve(retryResponse);
              } catch (_) {
                // fall through to the original error below
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static Future<String?> _tryRefreshAccessToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return null;
    try {
      final response = await _plainDio.post(
        ApiConstants.refreshToken,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
      final data = response.data;
      final newAccess = data is Map
          ? (data['access_token'] ?? data['accessToken'] ?? data['token'])
          : null;
      if (newAccess is String) {
        await TokenStorage.saveAccessOnly(newAccess);
        return newAccess;
      }
    } catch (_) {
      // refresh failed — caller will surface the original 401
    }
    return null;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    bool useRefreshToken = false,
  }) {
    return _dio.get(
      path,
      queryParameters: query,
      options: Options(extra: {_forceRefreshTokenKey: useRefreshToken}),
    );
  }

  static Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? query,
  }) {
    return _dio.post(path, data: formData ?? data, queryParameters: query);
  }

  static Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) {
    return _dio.put(path, data: formData ?? data);
  }

  static Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}

// Prints every request/response/error to the `flutter run` console —
// debug builds only. Makes it easy to see exactly what the app sent
// and what the API replied, without needing Postman.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️  ${options.method} ${options.uri}');
    if (options.headers['Authorization'] != null) {
      final token = options.headers['Authorization'].toString();
      final short = token.length > 40 ? '${token.substring(0, 40)}…' : token;
      debugPrint('   Authorization: $short');
    }
    final body = options.data;
    if (body != null) {
      if (body is FormData) {
        final fields = body.fields.map((f) => '${f.key}=${f.value}').join(', ');
        debugPrint('   Body (form-data): $fields');
      } else {
        debugPrint('   Body: $body');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    debugPrint('   Response: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '❌ ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    debugPrint('   Error: ${err.response?.data ?? err.message}');
    handler.next(err);
  }
}
