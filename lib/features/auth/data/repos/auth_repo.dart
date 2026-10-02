import 'package:dio/dio.dart';
import 'package:shop/core/network/api_constants.dart';
import 'package:shop/core/network/dio_helper.dart';
import 'package:shop/core/network/token_storage.dart';
import 'package:shop/features/auth/data/models/user_model.dart';

class AuthRepo {
  // CONFIRMED from a real login response: {"access_token": "...",
  // "refresh_token": "..."} — no wrapper, no user object.
  static Map<String, String?> _extractTokens(dynamic data) {
    if (data is! Map) return {'access': null, 'refresh': null};
    final access = data['access_token'] ?? data['accessToken'] ?? data['token'];
    final refresh = data['refresh_token'] ?? data['refreshToken'];
    return {'access': access?.toString(), 'refresh': refresh?.toString()};
  }

  static UserModel? _extractUser(dynamic data) {
    if (data is! Map) return null;
    final userJson = data['user'] ?? data['data'];
    if (userJson is Map<String, dynamic>) return UserModel.fromJson(userJson);
    // Some APIs flatten the user fields into the top-level response.
    if (data.containsKey('email') || data.containsKey('name')) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await DioHelper.post(
      ApiConstants.register,
      formData: FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );
    // Confirmed: register only returns {"message": ..., "status": true} —
    // no tokens and no user object. So log in right after with the same
    // credentials to actually start a session.
    final data = response.data;
    final registered = data is Map && (data['status'] == true || data['status'] == 'true');
    if (!registered && data is Map && data['status'] == false) {
      throw Exception(data['message']?.toString() ?? 'Registration failed');
    }
    return login(email: email, password: password);
  }

  static Future<UserModel?> login({required String email, required String password}) async {
    final response = await DioHelper.post(
      ApiConstants.login,
      formData: FormData.fromMap({'email': email, 'password': password}),
    );
    final tokens = _extractTokens(response.data);
    if (tokens['access'] != null) {
      await TokenStorage.save(access: tokens['access']!, refresh: tokens['refresh']);
    }
    return _extractUser(response.data) ?? await getUserData();
  }

  // get_user_data is confirmed (via live testing) to reject the
  // access_token and require the refresh_token specifically — every
  // other endpoint uses the access_token normally. Likely a backend
  // quirk/bug scoped to just this one route.
  static Future<UserModel?> getUserData() async {
    final response =
        await DioHelper.get(ApiConstants.getUserData, useRefreshToken: true);
    final data = response.data;
    if (data is Map) {
      final userJson = data['user'] ?? data['data'] ?? data;
      return UserModel.fromJson(Map<String, dynamic>.from(userJson));
    }
    return null;
  }

  static Future<void> updateProfile({required String name, required String phone}) async {
    await DioHelper.put(
      ApiConstants.updateProfile,
      formData: FormData.fromMap({'name': name, 'phone': phone}),
    );
  }

  static Future<void> deleteAccount() async {
    await DioHelper.delete(ApiConstants.deleteUser);
  }

  static Future<void> logout() async {
    await TokenStorage.clear();
  }
}
