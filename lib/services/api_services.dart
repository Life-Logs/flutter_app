import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://lifelog.devtkim.com";

  static Future getId() async {
    final url = Uri.parse('$baseUrl/auth/to-google');
    final response = await http.get(url);

    return response;
  }
}
