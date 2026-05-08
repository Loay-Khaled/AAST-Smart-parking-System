import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static Future<Map<String, String>> _headers({bool requiresAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      final token = await AuthService.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Request failed';
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? message;
      } catch (_) {}
      throw Exception(message);
    }
  }

  static Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url), headers: await _headers());
    _checkResponse(response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> post(String url, Map<String, dynamic> body,
      {bool requiresAuth = true}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(requiresAuth: requiresAuth),
      body: jsonEncode(body),
    );
    _checkResponse(response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> patch(String url, [Map<String, dynamic>? body]) async {
    final response = await http.patch(
      Uri.parse(url),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    _checkResponse(response);
    return jsonDecode(response.body);
  }

  static Future<dynamic> delete(String url) async {
    final response = await http.delete(Uri.parse(url), headers: await _headers());
    _checkResponse(response);
    return jsonDecode(response.body);
  }
}
