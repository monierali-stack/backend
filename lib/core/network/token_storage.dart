import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static Future<void> save({required String access, String? refresh}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    if (refresh != null) {
      await prefs.setString(_refreshKey, refresh);
    }
  }

  static Future<void> saveAccessOnly(String access) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
