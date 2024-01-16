import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lifelog/models/routine_model.dart';
import 'package:lifelog/services/shared_pref.dart';

class ApiService {
  static const String baseUrl = "https://dev.lifelog.devtkim.com";

  static Future getId() async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.get(url);

    return response;
  }

  static Future getUserInfo() async {
    final headers = {'cookie': await getStoredCookie()};
    final url = Uri.parse('$baseUrl/auth/cookie-validation');
    final response = await http.get(url, headers: headers);

    return response;
  }

  static Future<List<RoutineModel>> getAllRoutine() async {
    final url = Uri.parse('$baseUrl/routine');
    final response = await http.get(url);

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

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $authToken',
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

      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $authToken',
      });

      if (response.statusCode == 201) {
        final body = response.body;
        return body;
      } else {
        print("Failed to update routine. Status code: ${response.statusCode}");
        return (response.body);
      }
    } catch (e) {
      return ("Error: $e");
    }
  }
}
