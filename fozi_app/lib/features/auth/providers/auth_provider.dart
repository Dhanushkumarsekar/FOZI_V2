import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_service.dart';

class AuthProvider extends ChangeNotifier {

  String? token;
  String? userId;
  String? name;
  String? email;
  String? image;
  bool isAdmin = false;

  bool get isLoggedIn => token != null;

  /// 🔐 EMAIL LOGIN
  Future<bool> login(String email, String password) async {
    final data = await ApiService.login(
      email: email,
      password: password,
    );

    if (data != null) {
      _setUserData(data);
      return true;
    }

    return false;
  }

  /// 🔥 GOOGLE LOGIN
  Future<void> loginWithGoogle(Map data) async {
    print(data);
    _setUserData(data);
  }

  /// 🔥 COMMON SETTER
  Future<void> _setUserData(Map data) async {

    token = data['token'];
    userId = data['user']['_id'];
    name = data['user']['name'];
    email = data['user']['email'];
    image = data['user']['picture'];
    isAdmin = data['user']['isAdmin'] ?? false;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token!);
    await prefs.setString("userId", userId!);
    await prefs.setString("name", name ?? "");
    await prefs.setString("email", email ?? "");
    await prefs.setString("image", image ?? "");
    await prefs.setBool("isAdmin", isAdmin);

    notifyListeners();
  }

  /// 🔁 AUTO LOGIN
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    userId = prefs.getString("userId");
    name = prefs.getString("name");
    email = prefs.getString("email");
    image = prefs.getString("image");
    isAdmin = prefs.getBool("isAdmin") ?? false;

    if (token != null) {
      notifyListeners();
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    token = null;
    userId = null;
    name = null;
    email = null;
    image = null;
    isAdmin = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}