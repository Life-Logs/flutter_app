import 'package:shared_preferences/shared_preferences.dart';

Future<String> getStoredCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String storedCookie = prefs.getString('cookie') ?? '';

  return storedCookie;
}
