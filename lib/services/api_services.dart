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
}
