import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'api_constants.dart';
import '../models/user.dart';

class AuthService {
  static const _tokenKey = 'jwt_token';
  static const _userKey = 'user_json';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> isAdmin() async {
    final user = await getUser();
    return user?.isAdmin ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final data = await ApiService.post(
        ApiConstants.login,
        {'email': email, 'password': password},
        requiresAuth: false,
      );
      await _saveSession(data);
      return {'success': true, 'user': User.fromJson(data['user'])};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String carPlate) async {
    try {
      final data = await ApiService.post(
        ApiConstants.register,
        {'name': name, 'email': email, 'password': password, 'carPlate': carPlate},
        requiresAuth: false,
      );
      await _saveSession(data);
      return {'success': true, 'user': User.fromJson(data['user'])};
    } catch (e) {
      return {'success': false, 'message': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  static Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, data['token']);
    await prefs.setString(_userKey, jsonEncode(data['user']));
  }
}
