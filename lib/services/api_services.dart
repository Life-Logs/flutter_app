import 'package:http/http.dart' as http;
import 'package:lifelog/services/shared_pref.dart';

class ApiService {
  static const String baseUrl = "https://lifelog.devtkim.com";

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
}
