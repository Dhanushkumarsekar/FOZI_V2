
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';

class ApiClient {
  static String? token;

  static Future<http.Response> get(String endpoint) async {
    return http.get(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: _headers(),
    );
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + endpoint),
      headers: _headers(),
      body: jsonEncode(body),
    );
  }

  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
