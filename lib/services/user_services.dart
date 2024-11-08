import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class UserService {
  Future<Map<String, dynamic>?> registerUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> verifyOTP(String otp, String token) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/users/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp': otp,
        'token': token,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchUser(String email) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/users/search?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
