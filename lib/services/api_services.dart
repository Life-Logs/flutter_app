import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:lifelog/models/routine_model.dart';
import 'package:lifelog/services/auth_store.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_HOST'] ?? '';

  static Future<String?> _getToken() async {
    TokenStorage tokenStorage = TokenStorage();
    return tokenStorage.getToken();
  }

  static Future kakaoLogin(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  // static Future getUserInfo() async {
  //   final headers = {'cookie': await getStoredCookie()};
  //   final url = Uri.parse('$baseUrl/auth/cookie-validation');
  //   final response = await http.get(url, headers: headers);

  //   return response;
  // }

  static Future<List<RoutineModel>> getAllRoutine() async {
    final url = Uri.parse('$baseUrl/routine');
    String? token = await _getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => RoutineModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future createRoutine(routineData) async {
    try {
      final url = Uri.parse('$baseUrl/routine');
      String? token = await _getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(routineData),
      );

      if (response.statusCode == 201) {
        final body = response.body;
        return body;
      } else {
        print("Failed to create routine. Status code: ${response.statusCode}");
        return (response.body);
      }
    } catch (e) {
      return ("Error: $e");
    }
  }

  static Future deleteRoutine(id) async {
    try {
      final url = Uri.parse('$baseUrl/routine/$id');
      String? token = await _getToken();

      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 201) {
        final body = response.body;
        return body;
      } else {
        print("Failed to delete routine. Status code: ${response.statusCode}");
        return (response.body);
      }
    } catch (e) {
      return ("Error: $e");
    }
  }

  static Future toggleRoutine(id, toggleBool) async {
    try {
      final url = Uri.parse('$baseUrl/routine/$id/toggle-activation');
      String? token = await _getToken();

      final response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"isActived": toggleBool}));

      if (response.statusCode == 201) {
        final body = response.body;
        return body;
      } else {
        print(
            "Failed to update activation routine. Status code: ${response.statusCode}");
        return (response.body);
      }
    } catch (e) {
      return ("Error: $e");
    }
  }
}
