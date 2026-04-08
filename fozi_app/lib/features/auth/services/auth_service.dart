// Auth Service
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  static const String _loginKey = "isLoggedIn";

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }
}
